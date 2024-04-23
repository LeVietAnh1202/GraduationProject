from __future__ import absolute_import, division, print_function

import datetime
import time

import imageio

import facenet
import detect_face
from PIL import Image

import streamlit as st
import os
import cv2
import numpy as np
import pickle
import tensorflow.compat.v1 as tf

# import pyttsx3
# from pyttsx3 import engine

import pandas as pd

st.set_page_config(layout='wide')
st.sidebar.title('Main menu')

menu = ['Ảnh', 'Camera']
choice = st.sidebar.selectbox('Vui lòng chọn thông tin dữ liệu đầu vào', menu)

st.title('Phần mềm điểm danh khuôn mặt')

st.sidebar.title('Thông tin sinh viên')
id_container = st.sidebar.empty()
name_container = st.sidebar.empty()

id_container.info('Mã sinh viên: ?')
name_container.info('Họ và tên sinh viên: ?')
# load essential component
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
    HumanNames.sort()

    return pnet, rnet, onet, minsize, threshold, factor, margin, batch_size, image_size, input_image_size, HumanNames

def load_model_tensor(classifier_filename):
    images_placeholder = tf.get_default_graph().get_tensor_by_name("input:0")
    embeddings = tf.get_default_graph().get_tensor_by_name("embeddings:0")
    phase_train_placeholder = tf.get_default_graph().get_tensor_by_name("phase_train:0")
    embedding_size = embeddings.get_shape()[1]
    classifier_filename_exp = os.path.expanduser(classifier_filename)

    return images_placeholder, embeddings, phase_train_placeholder, embedding_size, classifier_filename_exp

def recognition_video(frame):
    id = ''
    fullName = ''

    if frame.ndim == 2:
        frame = facenet.to_rgb(frame)
    bounding_boxes, _ = detect_face.detect_face(frame, minsize, pnet, rnet, onet, threshold, factor)
    faceNum = bounding_boxes.shape[0]

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

                if best_class_probabilities > 0.8:
                    cv2.rectangle(frame, (x_min, y_min), (x_max, y_max), (236, 0, 242), 2)  # boxing face
                    for H_i in HumanNames:
                        if HumanNames[best_class_indices[0]] == H_i:
                            result_names = HumanNames[best_class_indices[0]]
                            id = str(result_names).split(' - ')[0]
                            fullName = str(result_names).split(' - ')[1]
                            print("Predictions : [ name: {} , accuracy: {:.3f} ]".format(
                                fullName, best_class_probabilities[0]))
                            cv2.rectangle(frame, (x_min, y_min-20), (x_max, y_min-2), (0, 255, 255), -1)
                            cv2.putText(frame, id, (x_min, y_min - 5), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (236, 0, 242), thickness=1, lineType=1)
                else:
                    id = '???'
                    fullName = '???'
                    cv2.rectangle(frame, (x_min, y_min), (x_max, y_max), (236, 0, 242), 2)
                    cv2.rectangle(frame, (x_min, y_min-20), (x_max, y_min-2), (0, 255, 255), -1)
                    cv2.putText(frame, "???", (x_min, y_min - 5), cv2.FONT_HERSHEY_COMPLEX_SMALL, 1,
                                (236, 0, 242), thickness=1, lineType=1)
            except Exception as ex:
                st.error(f'Đã có lỗi: {str(ex)}', icon='❌')
                continue
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

def mark_attendance(id, fullname):
    pass

avatar_state = None

if choice != 'Camera':
    uploaded_images = st.file_uploader('Tải ảnh lên để phục vụ quá trình nhận dạng khuôn mặt', type=['jpg', 'png', 'jpeg'], accept_multiple_files=True)
    with tf.Graph().as_default():
        sess = gpu_configuration()

        with sess.as_default():
            pnet, rnet, onet, minsize, threshold, factor, margin, batch_size, image_size, input_image_size, HumanNames = MTCNN_configuration(sess=sess, npy=npy, train_img=train_img)

            facenet.load_model(modeldir)
            st.success('Tải mô hình nhận dạng khuôn mặt thành công', icon='✔')

            images_placeholder, embeddings, phase_train_placeholder, embedding_size, classifier_filename_exp = load_model_tensor(classifier_filename=classifier_filename)
            with open(classifier_filename_exp, 'rb') as infile:
                (model, class_names) = pickle.load(infile, encoding='latin1')

                if len(uploaded_images) == 0:
                    st.info('Hãy tải lên ảnh muốn nhận dạng')
                else:
                    for image in uploaded_images:
                        # face recognition
                        image, id, fullName = recognition(imageio.imread(image))
                        # image showing
                        st.image(image)
                        if id != '???':
                            id_container.info(f'Mã sinh viên: {id}')
                            name_container.info(f'Họ và tên sinh viên: {fullName}')
                            avatar_state = f'./avatar_dataset/{id}.jpg'
                            avatar_container = st.sidebar.image(avatar_state)

                            text2speech(fullname=fullName, rate=150)
                        else:
                            id_container.info(f'Mã sinh viên: {id}')
                            name_container.info(f'Họ và tên sinh viên: {fullName}')
else:
    video = 0
    logged_id = []
    attendance_data = pd.DataFrame(columns=['Mã sinh viên', 'Họ và tên', 'Giờ điểm danh'])

    with tf.Graph().as_default():
        sess = gpu_configuration()
        with sess.as_default():
            pnet, rnet, onet, minsize, threshold, factor, margin, batch_size, image_size, input_image_size, HumanNames = MTCNN_configuration(sess=sess, npy=npy, train_img=train_img)
            facenet.load_model(modeldir)
            st.success('Model loaded successfully')
            images_placeholder, embeddings, phase_train_placeholder, embedding_size, classifier_filename_exp = load_model_tensor(classifier_filename=classifier_filename)
            with open(classifier_filename_exp, 'rb') as infile:
                (model, class_names) = pickle.load(infile, encoding='latin1')
            cap = cv2.VideoCapture(video)
            cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
            cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
            FRAME_WINDOWS = st.image([])
            while cap.isOpened():
                ret, frame = cap.read()
                if not ret:
                    st.error('Đã có lỗi khi khởi động camera')
                    st.error('Vui lòng tắt các ứng dụng khác đang sử dụng camera và khởi động lại ứng dụng')
                    st.stop()
                frame, id, fullName = recognition_video(frame)
                frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                FRAME_WINDOWS.image(frame)

                id_container.info(f'Mã sinh viên: {id}')
                name_container.info(f'Họ và tên sinh viên: {fullName}')
                if id not in logged_id and id != '???' and id != '':
                    logged_id.append(id)
                    current_time = pd.Timestamp.now()
                    new_mark_attendance = {'Mã sinh viên': id, 'Họ và tên': fullName, 'Giờ điểm danh': current_time}
                    attendance_data = pd.concat([attendance_data, pd.DataFrame([new_mark_attendance])], ignore_index=True)

                attendance_data.to_excel(f'{datetime.datetime.now().date()}.xlsx', index=False)

# with st.sidebar.form(key='my_form'):
#     st.title('Deverloper Section')
#     submit_button = st.form_submit_button(label='Retrain model')
#     if submit_button:
#         with st.spinner('Retraining the model...'):
#             # train model function
#             pass
#         st.success('Model has been retrained successfully!')