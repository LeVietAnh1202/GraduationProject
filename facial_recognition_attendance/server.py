# from typing import Union
# from fastapi import FastAPI, responses, Form
# from fastapi.middleware.cors import CORSMiddleware
# from fastapi.staticfiles import StaticFiles
# from fastapi.responses import StreamingResponse

# # from preprocess import preprocesses
# # from service.video_process import video_process
# # from classifier import training
# import os
# import cv2
# import numpy as np
# # import tensorflow.compat.v1 as tf
# # import facenet
# # import detect_face
# # import pickle
# from uvicorn import run
# from pydantic import BaseModel
# from typing import Optional
# import socketio
# import pandas as pd
# import logging

# # Set up logging
# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)

# # Tạo một Socket.IO server không đồng bộ
# sio = socketio.AsyncServer(async_mode='asgi')

# app = FastAPI()

# # Add middleware CORS
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],  # Cho phép tất cả các origin, bạn có thể chỉ định các origin cụ thể nếu cần thiết
#     allow_credentials=True,
#     allow_methods=["*"],  # Cho phép tất cả các phương thức HTTP
#     allow_headers=["*"],  # Cho phép tất cả các header
# )

# # Đường dẫn tới thư mục tĩnh
# static_directory = "train_img"

# # Tích hợp Socket.IO server với FastAPI
# app.mount('/', socketio.ASGIApp(sio, other_asgi_app=app, socketio_path='socketio'))

# # Mount thư mục tĩnh vào đường dẫn /train_img
# app.mount("/train_img", StaticFiles(directory=static_directory), name="train_img")
# app.mount("/public", StaticFiles(directory='public'), name="public")

# @app.get("/")
# def read_root():
#     return {"Hello": "World"}

# @app.get("/items/{item_id}")
# def read_item(item_id: str, q: Optional[str] = None):
#     return {"item_id": item_id, "q": q}

# @app.post("/train_model/")
# async def train_model():
#     # response = training.train()
#     # return response
#     print('train_model')
#     return {'result': 'done'}

# if __name__ == "__main__":
#     run("server:app", host="192.168.1.3", port=8001, reload=True)


import uvicorn
from fastapi import FastAPI
import socketio
from fastapi.middleware.cors import CORSMiddleware
# from sockets import sio_app

sio_server = socketio.AsyncServer(
    async_mode='asgi',
    cors_allowed_origins=[]
)

sio_app = socketio.ASGIApp(
    socketio_server=sio_server,
    socketio_path='sockets'
)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Cho phép tất cả các origin, bạn có thể chỉ định các origin cụ thể nếu cần thiết
    allow_credentials=True,
    allow_methods=["*"],  # Cho phép tất cả các phương thức HTTP
    allow_headers=["*"],  # Cho phép tất cả các header
)

# app.mount('', app=sio_app)


@app.get('/')
def home():
    return {'message': 'Hello world'}

@app.get('/about')
def home():
    return {'message': 'about'}

app.mount('/', socketio.ASGIApp(sio_server, socketio_path='sockets'))
@sio_server.event
async def connect(sid, environ, auth):
    print(f'{sid}: connected')

@sio_server.event
async def disconnect(sid):
    print(f'{sid}: disconnect')


if __name__ == '__main__':
    uvicorn.run('server:app', host='192.168.1.3', port=8001, reload=True)