async def connect_camera(sio, sid, data):
    # Thiết lập biến môi trường cho OpenCV với tùy chọn rtsp_transport là udp
    os.environ["OPENCV_FFMPEG_CAPTURE_OPTIONS"] = "rtsp_transport;udp"
    logged_id = []
    statusRecognize = data['status']
    if (statusRecognize):
        ids = data['ids']
        dayID = data['dayID']
        period = data['period']

    def capture_frames():
        print('khởi tạo camera')
        cap = cv2.VideoCapture('rtsp://admin:Vietanh123@192.168.1.2:554/0', cv2.CAP_FFMPEG)
        cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
        cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)

        while not stop_flag.is_set() and cap.isOpened():
            # print('isOpended')
            ret, frame = cap.read()
            if not ret:
                print("Không thể đọc khung hình")
                break
            if frame_queue.full():
                frame_queue.get()
            frame_queue.put(frame)
        cap.release()

    with tf.Graph().as_default():
        sess = gpu_configuration()
        with sess.as_default():
            pnet, rnet, onet, minsize, threshold, factor, margin, batch_size, image_size, input_image_size, HumanNames = MTCNN_configuration(sess=sess, npy=npy, train_img=train_img)
            facenet.load_model(modeldir)
            images_placeholder, embeddings, phase_train_placeholder, embedding_size, classifier_filename_exp = load_model_tensor(classifier_filename=classifier_filename)
            with open(classifier_filename_exp, 'rb') as infile:
                (model, class_names) = pickle.load(infile, encoding='latin1')  

            capture_thread = threading.Thread(target=capture_frames)
            capture_thread.daemon = True
            capture_thread.start()        
            
            while statusRecognize:
                if cv2.waitKey(1) == ord('q'):
                    stop_flag.set()
                    break
                if not frame_queue.empty():
                    print('frame_queue.empty() true')
                    frame = frame_queue.get()
                    frame_copy = frame.copy()
                    cv2.imshow('frame', frame)
                    frame, id, fullName = recognition_video(frame, minsize, pnet, rnet, onet, threshold, factor, image_size, input_image_size, HumanNames, images_placeholder, embeddings, phase_train_placeholder, embedding_size, sess, model)
                    frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                    
                    print(f'12520088 in ids: {"12520088" in ids}')
                    print(f'10120620 in ids: {"10120620" in ids}')
                    if id in ids:
                        current_time = pd.Timestamp.now()
                        new_mark_attendance = {'Mã sinh viên': id, 'Họ và tên': fullName, 'Giờ điểm danh': str(current_time)}
                       
                        _, buffer = cv2.imencode('.jpg', frame_copy)
                        frame_encoded = base64.b64encode(buffer).decode('utf-8')
                       
                        # Tạo chuỗi thời gian có dạng yyyy-MM-DD_hh-mm-ss
                        formatted_time = globals_var.currentTime.strftime('%Y-%m-%d_%H-%M-%S')
                        image_path = f'{dayID}/{id}_{fullName}/{period}_{formatted_time}.jpg'
                        await sio.emit('facial_recognition_result', {'status': True, 'studentId': id, 'dayID': dayID, 'image': frame_encoded, 'image_path': image_path}, to=sid)
                        ids.remove(id)
                        print({'info': new_mark_attendance, 'dayID': dayID})
                    elif id == '???':
                        await sio.emit('facial_recognition_result', {'status': False, 'message': 'Không nhận diện được'}, to=sid)
                        print('Không nhận diện được')
                    else:
                        await sio.emit('facial_recognition_result', {'status': False, 'message': 'Doing...'}, to=sid)
                        print('id rỗng')
                else:
                    print('frame_queue.empty() false')
                    
            
            # cap.release()
            cv2.destroyAllWindows()
    return {"success": True}