const app = require("./app");
const db = require('./config/db')

const port = 3000;

const socket_client = require('./socketio_service/socket_client');
socket_client.socket
setInterval(socket_client.attendanceFunc, 1000)
setInterval(socket_client.updateSimulatedTime, 1000)
const server = require('http').createServer(app);
// const options = {
//     cors: {
//         origin: "*",
//         methods: ["GET", "POST"],
//         transports: ["websocket", "polling"],
//         credentials: true,
//     },
//     allowEIO3: true,
// };

// const io = require("socket.io")(server, options);

// const esp32Connections = {};

// const CheckAttendanceSocketIO = require("./socketio_service/check_attendance");

// io.on('connection', client => {
//     console.log(`New client connected`);

//     client.on('fromClient', data => {
//         // Xử lý dữ liệu từ Arduinos
//         console.log(data);

//         // Gửi phản hồi về Arduino
//         client.emit('fromServer', `${Number(data) + 1}`);

//     });
//     client.emit('ESPConnected', 'Connected ESP');


//     // client.on('toggleLight', data => {
//     //     // Xử lý chuyển đổi đèn từ Arduino
//     //     console.log(data);

//     //     // Lấy id của ESP32 gửi toggleLight từ dữ liệu
//     //     const esp32Id = data.espId;
//     //     console.log(esp32Id);
//     //     console.log(data.isLightOn);
//     //     // Kiểm tra xem ESP32 có tồn tại trong esp32Connections không
//     //     if (esp32Connections.hasOwnProperty(esp32Id)) {
//     //         // Gửi phản hồi về ESP32 tương ứng
//     //         console.log(esp32Connections[esp32Id])
//     //         io.to(esp32Connections[esp32Id].clientId).emit('toggleLightESP', data.isLightOn);
//     //     } else {
//     //         console.log(`ESP32 with ID ${esp32Id} is not registered`);
//     //     }
//     //     // io.emit('toggleLightESP', data);

//     //     // Gửi phản hồi về Arduino
//     //     // io.emit('toggleLightESP', data);
//     // });

//     client.on('registerEsp32', esp32Info => {
//         // Ghi nhận kết nối của ESP32 với thông tin về LED tương ứng
//         console.log(esp32Info);
//         esp32Connections[esp32Info.esp32Id] = {
//             clientId: client.id
//         };
//         console.log(`ESP32 with ID ${esp32Info.esp32Id} connected`);
//         // client.emit('registerEsp32', esp32Info);
//     });


//     // client.on('attendance', data => {
//     //     // Xử lý dữ liệu từ ESP32
//     //     console.log(data);

//     //     // Gửi phản hồi về ESP32 (nếu cần)
//     //     client.emit('dataReceived', 'Data received by server');

//     //     io.emit('attendance', data);
//     // });

//     client.on('currentTime', data => {
//         console.log(data);
//         global.currentTime = data;
//     })

//     client.on('disconnect', () => {
//         // Xóa thông tin kết nối của ESP32 khi nó ngắt kết nối
//         const disconnectedEsp32 = Object.entries(esp32Connections).find(entry => entry[1].clientId === client.id);
//         if (disconnectedEsp32) {
//             const esp32Id = disconnectedEsp32[0];
//             delete esp32Connections[esp32Id];
//             console.log(`ESP32 with ID ${esp32Id} disconnected`);
//         }

//         console.log(`Client disconnected`);
//     });
//     CheckAttendanceSocketIO.checkAttendanceSocketIO(io, client);

//     client.on('disconnect', () => console.log(`Client disconnected`));
// });



server.listen(port, () => {
    console.log(`Server Listening on Port http://localhost:${port}`);


})