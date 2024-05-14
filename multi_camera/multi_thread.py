import threading
import cv2
import datetime
import random

def process_camera(camera_id):
    # current_time = datetime.datetime.now()
    video_capture = cv2.VideoCapture(camera_id)
    if not video_capture.isOpened():
        print("Error: Could not open camera.")
        return
    else:
        print("Camera opened")

    while True:
        
        ret, frame = video_capture.read()
        cv2.imshow('{}'.format(id), frame)        
        
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        # if current_time > end_time:
        #     break

    video_capture.release()

def main():
    url1 = "rtsp://192.168.1.2:1202/h264_opus.sdp"
    # url2 = "rtsp://192.168.1.2:1202/h264_opus.sdp"
    attendance_cameras = [0, url1]

    if attendance_cameras:
        # # Tính thời gian bắt đầu điểm danh
        # start_time = datetime.datetime.now()
        
        # # Tính thời gian kết thúc điểm danh (thêm ngẫu nhiên 3-5 phút)
        # end_time = start_time + datetime.timedelta(minutes=random.randint(3, 5))

        # print(start_time)
        # print(end_time)
        for camera_id in attendance_cameras:
            # t = threading.Thread(target=process_camera, args=(camera_id,start_time, end_time,))
            t = threading.Thread(target=process_camera, args=(camera_id,))
            t.start()
    else:
        print("Không có buổi học đang diễn ra vào thời điểm hiện tại.")

if __name__ == "__main__":
    main()