from typing import Union
from fastapi import FastAPI, responses, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import StreamingResponse

from preprocess import preprocesses
from service.video_process import video_process
from classifier import training
import os
import cv2
import numpy as np
import tensorflow.compat.v1 as tf
import facenet
import detect_face
import pickle
from uvicorn import run
from pydantic import BaseModel
from typing import Optional
import socketio
import pandas as pd
from PIL import Image

# Tạo một Socket.IO server không đồng bộ
sio = socketio.AsyncServer(async_mode='asgi')

# # Tạo một ứng dụng FastAPI
# middleware = [
#     Middleware(CORSMiddleware, allow_origins=['*'], allow_methods=['*'], allow_headers=['*'])
# ]
# app = FastAPI(middleware=middleware)


app = FastAPI()

# Add middleware CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Cho phép tất cả các origin, bạn có thể chỉ định các origin cụ thể nếu cần thiết
    allow_credentials=True,
    allow_methods=["*"],  # Cho phép tất cả các phương thức HTTP
    allow_headers=["*"],  # Cho phép tất cả các header
)

# Đường dẫn tới thư mục tĩnh
static_directory = "train_img"

# Tích hợp Socket.IO server với FastAPI

# Mount thư mục tĩnh vào đường dẫn /train_img
app.mount("/train_img", StaticFiles(directory=static_directory), name="train_img")
app.mount("/public", StaticFiles(directory='public'), name="public")

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

class Video(BaseModel):
    video_path: str
    images_path: str

@app.post("/crop_video")
async def crop_video(video: Video):
    # images_path = './public/images/full_images'
    print(video.video_path)
    obj = video_process(video.video_path, video.images_path)
    image_count = -1
    image_count = obj.auto_capture_save_images(100, 200)
    return {"image_count": image_count}

@app.get("/process")
async def process_images():
    input_datadir = './train_img'
    output_datadir = './aligned_img'

    obj = preprocesses(input_datadir, output_datadir)
    nrof_images_total, nrof_successfully_aligned = obj.collect_data()

    result = {
        "total_images_processed": nrof_images_total,
        "successfully_aligned_images": nrof_successfully_aligned
    }

    return result

    # return StreamingResponse(obj.collect_data(), media_type="text/event-stream")

@app.get("/train_model")
def train_model():
    datadir = './aligned_img'
    modeldir = './model/20180402-114759.pb'
    classifier_filename = './class/classifier.pkl'

    print('start training')
    obj = training(datadir, modeldir, classifier_filename)
    print('done training')
    get_file = obj.main_train()

    # session = tf.compat.v1.Session()
    # tf.compat.v1.keras.backend.set_session(session)

    # Khởi tạo và chạy quá trình huấn luyện
    # obj = training(datadir, modeldir, classifier_filename)
    # # with session.as_default():
    # with tf.Graph().as_default():
    #     sess = gpu_configuration()
    #     with sess.as_default():
    #         get_file = obj.main_train()

    # @sio.event
    # async def train_model_done(sid):
    #     print('Train model done - to ', sid)
    #     await sio.emit('train_model_done', {'data': 'train model done'}, to=sid)
    # await sio.emit('train_model_done', {'data': 'train model done'}, to=sid)

    return {"result": "All done"}

app.mount('', socketio.ASGIApp(sio, other_asgi_app=app, socketio_path='socketio'))

# Import các sự kiện từ các tệp riêng
import sio_event

# Sự kiện nhận tin nhắn
@sio.event
async def facial_recognition(sid, data):
    print('facial_recognition - ', sid, ' - ', data)
    await connect_camera(sio, sid)
    # await sio.emit('message', {'data': data}, to=sid)





modeldir = './model/20180402-114759.pb'
classifier_filename = './class/classifier.pkl'
npy = './npy'
train_img = "./train_img"

def gpu_configuration():
    gpu_options = tf.GPUOptions(per_process_gpu_memory_fraction=0.7)
    sess = tf.Session(config=tf.ConfigProto(gpu_options=gpu_options, log_device_placement=False))
    return sess

def MTCNN_configuration(sess, npy, train_img):
    pnet, rnet, onet = detect_face.create_mtcnn(sess, npy)
    minsize = 30  # minimum size of face
    threshold = [0.7, 0.8, 0.8]  # three steps's threshold
    factor = 0.709  # scale factor
    margin = 44
    batch_size = 100  # 1000
    image_size = 182
    input_image_size = 160
    HumanNames = os.listdir(train_img)
    print('train_img' + train_img)
    HumanNames.sort()

    return pnet, rnet, onet, minsize, threshold, factor, margin, batch_size, image_size, input_image_size, HumanNames

def load_model_tensor(classifier_filename):
    images_placeholder = tf.get_default_graph().get_tensor_by_name("input:0")
    embeddings = tf.get_default_graph().get_tensor_by_name("embeddings:0")
    phase_train_placeholder = tf.get_default_graph().get_tensor_by_name("phase_train:0")
    embedding_size = embeddings.get_shape()[1]
    classifier_filename_exp = os.path.expanduser(classifier_filename)

    return images_placeholder, embeddings, phase_train_placeholder, embedding_size, classifier_filename_exp

def recognition_video(frame, minsize, pnet, rnet, onet, threshold, factor, image_size, input_image_size, HumanNames, images_placeholder, embeddings, phase_train_placeholder, embedding_size, sess, model):
    id = ''
    fullName = ''
    # print('frame: ' + str(frame))
    if frame.ndim == 2:
        frame = facenet.to_rgb(frame)
    bounding_boxes, _ = detect_face.detect_face(frame, minsize, pnet, rnet, onet, threshold, factor)
    faceNum = bounding_boxes.shape[0]
    print('faceNum: ' + str(faceNum))
    if faceNum > 0:
        det = bounding_boxes[:, 0:4]
        img_size = np.asarray(frame.shape)[0:2]
        cropped = []
        scaled = []
        scaled_reshape = []

        for i in range(faceNum):
            emb_array = np.zeros((1, embedding_size))
            x_min = int(det[i][0])
            y_min = int(det[i][1])
            x_max = int(det[i][2])
            y_max = int(det[i][3])

            try:
                # inner exception
                if x_min <= 0 or y_min <= 0 or x_max >= len(frame[0]) or y_max >= len(frame):
                    st.warning('Face is very close!', icon="⚠️")
                    continue
                print('processing face')
                cropped.append(frame[y_min: y_max, x_min: x_max, :])
                cropped[i] = facenet.flip(cropped[i], False)
                scaled.append(np.array(Image.fromarray(cropped[i]).resize((image_size, image_size))))
                scaled[i] = cv2.resize(scaled[i], (input_image_size, input_image_size),
                                       interpolation=cv2.INTER_CUBIC)
                scaled[i] = facenet.prewhiten(scaled[i])
                scaled_reshape.append(scaled[i].reshape(-1, input_image_size, input_image_size, 3))
                feed_dict = {images_placeholder: scaled_reshape[i], phase_train_placeholder: False}
                emb_array[0, :] = sess.run(embeddings, feed_dict=feed_dict)
                predictions = model.predict_proba(emb_array)
                best_class_indices = np.argmax(predictions, axis=1)
                best_class_probabilities = predictions[
                    np.arange(len(best_class_indices)), best_class_indices]
                print('best_class_probabilities:' + str(best_class_probabilities))
                if best_class_probabilities > 0.8:
                    cv2.rectangle(frame, (x_min, y_min), (x_max, y_max), (236, 0, 242), 2)  # boxing face
                    for H_i in HumanNames:
                        print('in for')
                        print(HumanNames[best_class_indices[0]] == H_i)
                        if HumanNames[best_class_indices[0]] == H_i:
                            print('1')
                            result_names = HumanNames[best_class_indices[0]]
                            print('2')
                            id = str(result_names).split('_')[0]
                            print('3')
                            fullName = str(result_names).split('_')[1]
                            print('4')
                            # print("Predictions : [ name: {} , accuracy: {:.3f} ]".format(
                            #     fullName, best_class_probabilities))
                            print("Predictions : [ name: {} , accuracy: {:.3f} ]".format(
                                fullName, best_class_probabilities[0]))
                            print('5')
                            cv2.rectangle(frame, (x_min, y_min-20), (x_max, y_min-2), (0, 255, 255), -1)
                            print('6')
                            cv2.putText(frame, id, (x_min, y_min - 5), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (236, 0, 242), thickness=1, lineType=1)
                else:
                    id = '???'
                    fullName = '???'
                    cv2.rectangle(frame, (x_min, y_min), (x_max, y_max), (236, 0, 242), 2)
                    cv2.rectangle(frame, (x_min, y_min-20), (x_max, y_min-2), (0, 255, 255), -1)
                    cv2.putText(frame, "???", (x_min, y_min - 5), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1,
                                (236, 0, 242), thickness=1, lineType=1)
            except Exception as ex:
                # st.error(f'Đã có lỗi: {str(ex)}', icon='❌')
                print(f"Đã có lỗi: {str(ex)}")
                continue
            print(f'f=end for {i}')
    return frame, id, fullName

def recognition(image):
    id = ''
    fullName = ''
    bounding_boxes, _ = detect_face.detect_face(image, minsize, pnet, rnet, onet, threshold, factor)
    faceNum = bounding_boxes.shape[0]

    if faceNum > 0:
        det = bounding_boxes[:, 0:4]
        img_size = np.asarray(image.shape)[0:2]
        cropped = []
        scaled = []
        scaled_reshape = []

        for i in range(faceNum):
            emb_array = np.zeros((1, embedding_size))
            x_min = int(det[i][0])
            y_min = int(det[i][1])
            x_max = int(det[i][2])
            y_max = int(det[i][3])

            cropped.append(image[y_min: y_max, x_min: x_max, :])
            cropped[i] = facenet.flip(cropped[i], False)
            scaled.append(np.array(Image.fromarray(cropped[i]).resize((image_size, image_size))))
            scaled[i] = cv2.resize(scaled[i], (input_image_size, input_image_size), interpolation=cv2.INTER_CUBIC)
            scaled[i] = facenet.prewhiten(scaled[i])
            scaled_reshape.append(scaled[i].reshape(-1, input_image_size, input_image_size, 3))
            feed_dict = {images_placeholder: scaled_reshape[i], phase_train_placeholder: False}
            emb_array[0, :] = sess.run(embeddings, feed_dict=feed_dict)
            predictions = model.predict_proba(emb_array)
            best_class_indices = np.argmax(predictions, axis=1)
            best_class_probabilities = predictions[np.arange(len(best_class_indices)), best_class_indices]

            if best_class_probabilities > 0.8:
                cv2.rectangle(image, (x_min, y_min), (x_max, y_max), (236, 0, 242), 2)  # boxing face
                for H_i in HumanNames:
                    if HumanNames[best_class_indices[0]] == H_i:
                        result_names = HumanNames[best_class_indices[0]]
                        id = str(HumanNames[best_class_indices[0]]).split(' - ')[0]
                        fullName = str(HumanNames[best_class_indices[0]]).split(' - ')[1]
                        print("Predictions : [ name: {} , accuracy: {:.3f} ]".format(result_names,
                                                                                     best_class_probabilities[0]))
                        cv2.rectangle(image, (x_min, y_min-20), (x_max, y_min-2), (0, 255, 255), -1)
                        cv2.putText(image, id, (x_min, y_min - 5), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (236, 0, 242), thickness=1, lineType=1)

            else:
                id = '???'
                fullName = '???'
                cv2.rectangle(image, (x_min, y_min), (x_max, y_max), (236, 0, 242), 2)
                cv2.rectangle(image, (x_min, y_min-20), (x_max, y_min-2), (0, 255, 255), -1)
                cv2.putText(image, "???", (x_min, y_min - 5), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (236, 0, 242), thickness=1, lineType=1)
    return image, id, fullName

def text2speech(fullname, rate=150):
    engine = pyttsx3.init()

    voices = engine.getProperty("voices")
    engine.setProperty("voice", voices[1].id)
    engine.setProperty("rate", rate)
    engine.setProperty("volume", 1.0)
    engine.say(f'Xin chào {fullname}')
    engine.runAndWait()

# @app.get("/connect_camera")
async def connect_camera(sio, sid):
    logged_id = []

    with tf.Graph().as_default():
        sess = gpu_configuration()
        with sess.as_default():
            pnet, rnet, onet, minsize, threshold, factor, margin, batch_size, image_size, input_image_size, HumanNames = MTCNN_configuration(sess=sess, npy=npy, train_img=train_img)
            facenet.load_model(modeldir)
            # st.success('Model loaded successfully')
            images_placeholder, embeddings, phase_train_placeholder, embedding_size, classifier_filename_exp = load_model_tensor(classifier_filename=classifier_filename)
            with open(classifier_filename_exp, 'rb') as infile:
                (model, class_names) = pickle.load(infile, encoding='latin1')
            # cap = cv2.VideoCapture('rtsp://192.168.1.162:1202/h264_ulaw.sdp')
            cap = cv2.VideoCapture(0)
            cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
            cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
            # FRAME_WINDOWS = st.image([])
            while cap.isOpened():
                if cv2.waitKey(1) == ord('q'):
                    break
                print('cap.isOpened')
                ret, frame = cap.read()
                cv2.imshow('frame', frame)
                # if not ret:
                    # st.error('Đã có lỗi khi khởi động camera')
                    # st.error('Vui lòng tắt các ứng dụng khác đang sử dụng camera và khởi động lại ứng dụng')
                    # st.stop()
                frame, id, fullName = recognition_video(frame, minsize, pnet, rnet, onet, threshold, factor, image_size, input_image_size, HumanNames, images_placeholder, embeddings, phase_train_placeholder, embedding_size, sess, model)
                frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                # FRAME_WINDOWS.image(frame)
                print(id)
                # id_container.info(f'Mã sinh viên: {id}')
                # name_container.info(f'Họ và tên sinh viên: {fullName}')
                if id != '???' and id != '':
                # if id not in logged_id and id != '???' and id != '':
                    logged_id.append(id)
                current_time = pd.Timestamp.now()
                new_mark_attendance = {'Mã sinh viên': id, 'Họ và tên': fullName, 'Giờ điểm danh': str(current_time)}
                await sio.emit('facial_recognition_result', {'data': new_mark_attendance}, to=sid)
                print(new_mark_attendance)
                #     attendance_data = pd.concat([attendance_data, pd.DataFrame([new_mark_attendance])], ignore_index=True)

                # attendance_data.to_excel(f'{datetime.datetime.now().date()}.xlsx', index=False)
            cap.release()
            cv2.destroyAllWindows()
    return {"success": True}
# connect_camera()

def _get_frame():
    frame = np.random.randint(low=0, high=255, size=(480,640, 3), dtype='uint8')
    return frame

# def generate_frames():
#     # cap = cv2.VideoCapture(0)
#     # if not cap.isOpened():
#     #     print("Error: Could not open camera.")
#     #     yield (b'--frame\r\nContent-Type: text/plain\r\n\r\nError: Could not open camera.\r\n')
#     #     return
    
#     # while True:
#     #     # ret, frame = cap.read()
#     #     # if not ret:
#     #     #     print("Error: Could not read frame.")
#     #     #     break
        
#     #     # frame = detect_face(frame)
#     #     ret, buffer = cv2.imencode('.png', _get_frame())
#     #     # ret, buffer = cv2.imencode('.jpg', frame)
#     #     if not ret:
#     #         print("Error: Could not encode frame.")
#     #         break
#     #     # cv2.imshow('frame', frame)
#     #     frame_bytes = buffer.tobytes()
#     #     # # yield (b'--frame\r\nContent-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')
#     #     yield (frame_bytes)
        
#     ret, buffer = cv2.imencode('.png', _get_frame())
#     if not ret:
#         print("Error: Could not encode frame.")
#         break
#     frame_bytes = buffer.tobytes()
#     yield (frame_bytes)
#     # cap.release()
#     # cap.destroyAllWindows()

# @app.get('/video_frame')
# async def video_frame():
#     return responses.StreamingResponse(generate_frames())
#     # return responses.StreamingResponse(generate_frames(), media_type='multipart/x-mixed-replace; boundary=frame')


def main():
    run("server:app", host="192.168.1.9", port=8001, reload=True)

if __name__ == '__main__':
    main()

# print("main")
# connect_camera()