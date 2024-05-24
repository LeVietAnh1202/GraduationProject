def connect_camera():
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
                frame, id, fullName = recognition_video(frame, minsize, pnet, rnet, onet, threshold, factor, embedding_size)
                frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                # FRAME_WINDOWS.image(frame)
                print(id)
                # id_container.info(f'Mã sinh viên: {id}')
                # name_container.info(f'Họ và tên sinh viên: {fullName}')
                if id != '???' and id != '':
                # if id not in logged_id and id != '???' and id != '':
                    logged_id.append(id)
                    current_time = pd.Timestamp.now()
                    new_mark_attendance = {'Mã sinh viên': id, 'Họ và tên': fullName, 'Giờ điểm danh': current_time}
                    print(new_mark_attendance)
                #     attendance_data = pd.concat([attendance_data, pd.DataFrame([new_mark_attendance])], ignore_index=True)

                # attendance_data.to_excel(f'{datetime.datetime.now().date()}.xlsx', index=False)
            cap.release()
            cv2.destroyAllWindows()
    return {"success": True}