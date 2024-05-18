import os
import time
import cv2

class video_process:
    def __init__(self, input_datadir, output_datadir):
        self.input_datadir = input_datadir
        self.output_datadir = output_datadir

    def crop_video(video_name: str):
        return ''

    def auto_capture_save_images(self, capture_time_ms, total_pictures_limit):
        if not os.path.exists(self.output_datadir):
                os.makedirs(self.output_datadir)

        video = cv2.VideoCapture(self.input_datadir)  # Tạo một video stream từ mảng byte
        if video:
            video_name_with_ext = self.input_datadir.split('/')[-1]
            video_name, ext = os.path.splitext(video_name_with_ext)
            
            image_count = 1                                                                                          # Đặt biến đếm để đánh số ảnh
            timer = time.time() + (capture_time_ms / 1000)                                                           # Hẹn giờ để chụp ảnh mỗi giây
            face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')      # Tải pretrain classifier để phát hiện khuôn mặt
            while True:
                ret, frame = video.read()
                if frame is not None:
                    frame_copy = frame.copy()                                                                            # Tạo một bản sao của khung hình gốc để vẽ bounding box và hiển thị
                    gray_frame = cv2.cvtColor(frame_copy, cv2.COLOR_BGR2GRAY)
                    faces = face_cascade.detectMultiScale(gray_frame, scaleFactor=1.3, minNeighbors=5)
                    for (x, y, w, h) in faces:
                        cv2.rectangle(frame_copy, (x, y), (x+w, y+h), (0, 255, 0), 2)
                    cv2.imshow('Auto capture image for training', frame_copy)                                            # Hiển thị khung hình bản sao có bounding box

                    if time.time() >= timer and len(faces) > 0:                                                          # Kiểm tra nếu đến thời gian chụp ảnh và phát hiện được khuôn mặt
                        image_name = f"{self.output_datadir}/{image_count}.jpg"                                                # Tạo tên file ảnh dựa trên thời gian hiện tại

                        cv2.imwrite(image_name, frame)                                                                   # Lưu ảnh từ khung hình gốc vào thư mục đích
                        print(f"Saved image: {image_name}")
                        image_count += 1

                        if image_count > total_pictures_limit:
                            break
                        timer = time.time() + (capture_time_ms / 1000)                                                   # Cập nhật thời gian chụp ảnh tiếp theo

                    key = cv2.waitKey(1)
                    if key == 27:
                        break

            video.release()
            cv2.destroyAllWindows()
            return image_count - 1