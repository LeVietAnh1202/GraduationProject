import multiprocessing
import threading
import datetime
import random
import time
import cv2

def process_camera(camera_id, start_time, end_time):
    # # Viết mã xử lý điểm danh từ một camera cụ thể ở đây
    # # Trả về danh sách sinh viên có mặt từ camera
    current_time = datetime.datetime.now()
    # attendance_list = []
    # while current_time <= end_time:
    #     # Thực hiện điểm danh
    #     print(f"Đang điểm danh từ camera {camera_id}...")
    #     # Giả sử có một số xử lý điểm danh ở đây
    #     time.sleep(1)  # Giả định việc điểm danh mất 1 giây
    #     attendance_list.append("Student1")  # Thêm sinh viên vào danh sách điểm danh
    #     current_time = datetime.datetime.now()
    # return attendance_list

    cap = cv2.VideoCapture(camera_id)
    if not cap.isOpened():
        print("Error: Could not open camera.")
        return
    else:
        print("Camera opened")
    
    while True:
        ret, frame = cap.read()
        if not ret:
            print("Error: Could not read frame.")
            break
        cv2.imshow('frame', frame)
        # if current_time > end_time:
        #     break
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    print('end')
    return [f'Student_${camera_id}']

def query_schedule_from_database(current_time):
    # Viết mã để truy vấn thông tin lịch học từ MongoDB ở đây
    # Trả về danh sách các buổi học đang diễn ra tại thời điểm hiện tại
    pass

def determine_attendance_cameras():
    current_time = datetime.datetime.now()
    attendance_cameras = []

    # Tính toán thời điểm cần xác định các buổi học đang diễn ra
    start_times = [
        datetime.time(7, 10), datetime.time(8, 5), datetime.time(9, 0), datetime.time(9, 55),
        datetime.time(10, 45), datetime.time(12, 40), datetime.time(13, 35), datetime.time(14, 30),
        datetime.time(15, 25), datetime.time(16, 20)
    ]

    # Lấy thời gian hiện tại và trừ đi 5 phút
    current_time = current_time - datetime.timedelta(minutes=5)

    # Kiểm tra xem thời gian hiện tại có nằm trong khoảng thời gian của các buổi học không
    for start_time in start_times:
        class_start_time = datetime.datetime.combine(current_time.date(), start_time)

        if current_time.time() >= start_time and current_time <= class_start_time:
            # Truy vấn thông tin lịch học từ cơ sở dữ liệu
            # Ví dụ: lấy thông tin buổi học bắt đầu lúc start_time
            schedules = query_schedule_from_database(class_start_time)
            
            if schedules:
                attendance_cameras.append(schedules[0]["attendance_camera"])

    return attendance_cameras

def main():
    # Xác định danh sách camera điểm danh dựa trên lịch học và thời gian hiện tại
    # attendance_cameras = determine_attendance_cameras()
    attendance_cameras = [0, 'rtsp://192.168.1.2:1202/h264_opus.sdp']

    if attendance_cameras:
        # Tính thời gian bắt đầu điểm danh
        start_time = datetime.datetime.now()
        
        # Tính thời gian kết thúc điểm danh (thêm ngẫu nhiên 3-5 phút)
        end_time = start_time + datetime.timedelta(minutes=random.randint(3, 5))

        # Tạo danh sách các tiến trình để xử lý từng camera
        processes = []
        for camera_id in attendance_cameras:
            p = threading.Thread(target=process_camera, args=(camera_id, start_time, end_time))
            p.start()
            # processes.append(p)

        # # Chờ tất cả các tiến trình kết thúc trước khi tiếp tục
        # for p in processes:
        #     p.join()

        # # Tổng hợp kết quả từ camera điểm danh
        # combined_attendance_list = []
        # for p in processes:
        #     combined_attendance_list += p.exitcode

        # # Xử lý trùng lặp và kiểm tra độ tin cậy trong danh sách điểm danh tổng hợp
        # final_attendance_list = process_combined_attendance(combined_attendance_list)

        # # Gửi kết quả điểm danh đến NodeJS
        # send_attendance_to_nodejs(final_attendance_list)
    else:
        print("Không có buổi học đang diễn ra vào thời điểm hiện tại.")

def process_combined_attendance(attendance_lists):
    # Viết mã để xử lý trùng lặp và kiểm tra độ tin cậy trong danh sách điểm danh tổng hợp
    print(attendance_lists)
    pass

def send_attendance_to_nodejs(attendance_list):
    # Viết mã để gửi kết quả điểm danh đến NodeJS
    pass

if __name__ == "__main__":
    main()
