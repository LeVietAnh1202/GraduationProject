import socketio
import asyncio

sio_client = socketio.AsyncClient()

@sio_client.event
async def connect():
    print('Connected')

@sio_client.event
async def disconnect():
    print('Disconnected')

async def main():
    await sio_client.connect(url='http://192.168.1.3:8001/', socketio_path='sockets')
    await sio_client.wait()

if __name__ == '__main__':
    asyncio.run(main())