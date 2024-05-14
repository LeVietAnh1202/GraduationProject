# from fastapi import FastAPI, responses
# import numpy as np
# import cv2
# from uvicorn import run

# app = FastAPI()

# def _get_frame():
#     frame = np.random.randint(low=0, high=255, size=(480,640, 3), dtype='uint8')
#     return frame

# def generate_frames():
#     # cap = cv2.VideoCapture(0)
#     # if not cap.isOpened():
#     #     print("Error: Could not open camera.")
#     #     yield (b'--frame\r\nContent-Type: text/plain\r\n\r\nError: Could not open camera.\r\n')
#     #     return
    
#     while True:
#         # ret, frame = cap.read()
#         # if not ret:
#         #     print("Error: Could not read frame.")
#         #     break
        
#         # frame = detect_face(frame)
#         ret, buffer = cv2.imencode('.png', _get_frame())
#         # ret, buffer = cv2.imencode('.jpg', frame)
#         if not ret:
#             print("Error: Could not encode frame.")
#             break
#         # cv2.imshow('frame', frame)
#         frame_bytes = buffer.tobytes()
#         # # yield (b'--frame\r\nContent-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')
#         yield (frame_bytes)
#     print('out')
#     # cap.release()
#     # cap.destroyAllWindows()

# @app.get('/video_frame')
# async def video_frame():
#     return responses.StreamingResponse(generate_frames())
#     # return responses.StreamingResponse(generate_frames(), media_type='multipart/x-mixed-replace; boundary=frame')

# if __name__ == '__main__':
#     run("main:app", host="127.0.0.1", port=8001, reload=True)

from fastapi import FastAPI, responses
from uvicorn import run
from fastapi.middleware.cors import CORSMiddleware

import cv2
import numpy as np

app = FastAPI()

# Add middleware CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Cho phép tất cả các origin, bạn có thể chỉ định các origin cụ thể nếu cần thiết
    allow_credentials=True,
    allow_methods=["*"],  # Cho phép tất cả các phương thức HTTP
    allow_headers=["*"],  # Cho phép tất cả các header
)

def _get_frame():
    frame = np.random.randint(low=0, high=255, size=(480,640, 3), dtype='uint8')
    return frame

def generate():
    encodedImage = cv2.imencode('.png', _get_frame())[1]
    yield (encodedImage.tobytes())

@app.get("/video_frame")
async def video_feed():
    return responses.StreamingResponse(generate())

if __name__ == '__main__':
    run("video_stream:app", host="192.168.1.6", port=8001, reload=True)
