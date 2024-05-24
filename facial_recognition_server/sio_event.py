import socketio
from server import sio

# Sự kiện kết nối
@sio.event
async def connect(sid, environ):
    print('Client connected:', sid)
    await sio.emit('message', {'data': 'Welcome!'}, to=sid)

# Sự kiện ngắt kết nối
@sio.event
async def disconnect(sid):
    print('Client disconnected:', sid)

# Sự kiện nhận tin nhắn
@sio.event
async def message(sid, data):
    print('Message from', sid, ':', data)
    await sio.emit('message', {'data': data}, to=sid)

