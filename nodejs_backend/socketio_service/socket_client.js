const io = require('socket.io-client');
const path = require('path');
const fs = require('fs');
const ScheduleService = require('../services/schedule/schedule.service');

const socket = io('http://192.168.248.112:8001', {
    path: '/socketio'
});

socket.on('connect', () => {
    console.log('Connected to Python Socket.IO server');

    // Example: Send a message to the server
    socket.emit('message', { data: 'Hello from Node.js client!' });
});

socket.on('disconnect', () => {
    console.log('Disconnected from Python Socket.IO server');
});

socket.on('connect_error', (err) => {
    console.error('Connection error:', err);
});

// Handle other events from the server
socket.on('server_response', (data) => {
    console.log('Received from server:', data);
});

// client.on('currentTime', data => {
//     console.log(data);
//     global.currentTime = data;
// })

socket.on('facial_recognition_result', async (data) => {
    if (data['status']) {
        const buffer = Buffer.from(data['image'], 'base64');
        const imagePath = data['image_path'];
        const dir = path.dirname(imagePath);

        await fs.promises.mkdir(path.join(__dirname, '../public/images/attendance_images', dir), { recursive: true });

        const fullPath = path.join(__dirname, '../public/images/attendance_images', imagePath);
        await fs.promises.writeFile(fullPath, buffer);
    }
    else {
        console.log(data['message']);
    }
});

const attendanceFunc = async () => {
    console.log(`global.currentTime: ${global.currentTime}`)
    const gct = new Date(global.currentTime)

    const timeCheck = new Date(2024, 4, 10, 7, 15, 10)
    // if (global.currentTime && gct.toISOString() == timeCheck.toISOString()) {
    //     console.log('run socket facial_recognition');
    //     socket.emit('facial_recognition', { ids: ['12520088', '10120620'], dayID: '2222' });
    // }
    // else {
    //     console.log('khác tg')
    // }

    const currentMinutes = gct.getHours() * 3600 + gct.getMinutes() * 60 + gct.getSeconds();

    for (const [period, { start, end }] of Object.entries(ScheduleService.periodTimes)) {
        const [startHour, startMinute] = start.split(":").map(Number);
        const periodStartMinutes = startHour * 3600 + startMinute * 60;
        // const periodStartMinutes = startHour * 60 + startMinute;

        const timeDifference = periodStartMinutes - currentMinutes;

        if (timeDifference === 0) {
            const scheduleData = await ScheduleService.checkSchedule(gct);
            console.log('scheduleData:', scheduleData); // Kiểm tra dữ liệu nhận được
            socket.emit('update_time', { currentTime: global.currentTime });
            socket.emit('facial_recognition', { status: true, ids: scheduleData[0].listStudentID, dayID: scheduleData[0].dayID, period: period });
            // socket.emit('facial_recognition', { ids: ['12520088', '10120620'], dayID: '1012' });
            break;
        }
        else if (timeDifference === 10) {
            socket.emit('facial_recognition', { status: false });

        }
    }


}

const updateSimulatedTime = () => {
    if (global.currentTime) {
        const date = new Date(global.currentTime)
        const newDate = new Date(date.setSeconds(date.getSeconds() + 1))
        global.currentTime = newDate.toISOString();
    }
}

module.exports = {
    socket,
    attendanceFunc,
    updateSimulatedTime
};