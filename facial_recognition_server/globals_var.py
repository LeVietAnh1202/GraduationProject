from datetime import datetime, timedelta
import time
import threading

# Khai báo biến toàn cục
currentTime = datetime.now()

# Khởi tạo một khóa (lock) để kiểm soát quyền truy cập vào biến currentTime
time_lock = threading.Lock()

# Hàm để cập nhật currentTime mỗi giây
def update_time_continuously():
    global currentTime
    while True:
        time.sleep(1)
        with time_lock:
            currentTime += timedelta(seconds=1)
            print("Current Time:", currentTime)
            
# Khởi tạo và bắt đầu luồng để cập nhật thời gian liên tục
def start_time_thread():
    time_thread = threading.Thread(target=update_time_continuously)
    time_thread.daemon = True
    time_thread.start()