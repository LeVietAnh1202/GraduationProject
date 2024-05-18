# import threading
# import cv2
# import datetime
# import random

# def process_camera(camera_id, count):
#     # current_time = datetime.datetime.now()
#     video_capture = cv2.VideoCapture(camera_id)
#     # if not video_capture.isOpened():
#     #     print("Error: Could not open camera.")
#     #     return
#     # else:
#     #     print("Camera opened")

#     while True:
        
#         ret, frame = video_capture.read()
#         cv2.imshow('{}'.format(id), frame)        
        
#         if cv2.waitKey(1) & 0xFF == ord('q'):
#             break
#         # if current_time > end_time:
#         #     break

#     video_capture.release()

# def main():
#     url1 = "rtsp://192.168.1.8:1202/h264_opus.sdp"
#     # url2 = "rtsp://192.168.1.2:1202/h264_opus.sdp"
#     attendance_cameras = [url1, 0]
#     count = 0
#     # if attendance_cameras:
#     #     # # Tính thời gian bắt đầu điểm danh
#     #     # start_time = datetime.datetime.now()
        
#     #     # # Tính thời gian kết thúc điểm danh (thêm ngẫu nhiên 3-5 phút)
#     #     # end_time = start_time + datetime.timedelta(minutes=random.randint(3, 5))

#     #     # print(start_time)
#     #     # print(end_time)
#     #     for camera_id in attendance_cameras:
#     #         count += 1
#     #         # t = threading.Thread(target=process_camera, args=(camera_id,start_time, end_time,))
#     #         t = threading.Thread(target=process_camera, args=(camera_id, count,))
#     #         t.start()
#     # else:
#     #     print("Không có buổi học đang diễn ra vào thời điểm hiện tại.")

#     for camera_id in attendance_cameras:
#         count += 1
#         # t = threading.Thread(target=process_camera, args=(camera_id,start_time, end_time,))
#         t = threading.Thread(target=process_camera, args=(camera_id, count,))
#         t.start()

# if __name__ == "__main__":
#     main()

import threading
import cv2

def PlayCamera(id, count):    
    video_capture = cv2.VideoCapture(id)
    while True:
        
        ret, frame = video_capture.read()
        cv2.imshow('{}'.format(count), frame)        


        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    video_capture.release()

url1 = "rtsp://192.168.1.8:1202/h264_opus.sdp"
url2 = "rtsp://admin:Vietanh12021202@192.168.1.2:554/0"
cameraIDs = [url2]

count = 0
for id in cameraIDs:
    count += 1
    t = threading.Thread(target=PlayCamera, args=(id, count,))
    t.start()