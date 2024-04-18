const app = require('express')();
const server = require('http').createServer(app);
const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');
const options = {
    cors: {
        origin: "*",
        methods: ["GET", "POST"],
        transports: ["websocket", "polling"],
        credentials: true,
    },
    allowEIO3: true,
};

const io = require("socket.io")(server, options);

mongoose.connect('mongodb+srv://project:doanh2002@master.lbqzguz.mongodb.net/sensorData', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});

const fingerprintDataSchema = new mongoose.Schema({
    fingerprintId: String,
    timestamp: { type: Date, default: Date.now },
});

const FingerprintData = mongoose.model('FingerprintData', fingerprintDataSchema);

const fingerprintConnections = {};

app.get('/', (req, res) => {
    res.send('Hello World Nodejs....')
});

io.on('connection', client => {
    console.log(`New client connected`);

    client.on('fromClient', data => {
        // Xử lý dữ liệu từ phần cứng
        const fingerprintId = data.fingerprintId;

        // Lưu trữ dữ liệu vào CSDL MongoDB
        const fingerprintData = new FingerprintData({
            fingerprintId: fingerprintId,
            timestamp: Date.now()
        });
        fingerprintData.save()
            .then(() => console.log('Fingerprint data saved to MongoDB'))
            .catch(error => console.log('Error saving fingerprint data:', error));

        // Gửi phản hồi về phần cứng
        client.emit('fromServer', `${fingerprintId} received by server`);
    });

    client.on('sendData', async () => {
        try {
            const fingerprintData = await FingerprintData.find()
                .sort({ timestamp: -1 })
                .limit(10);

            // Gửi dữ liệu vân tay lên client Flutter
            client.emit('fingerprintData', fingerprintData);
        } catch (error) {
            console.error('Error retrieving fingerprint data:', error);
        }
    });

    client.on('disconnect', () => {
        // Xóa thông tin kết nối của phần cứng khi nó ngắt kết nối
        const disconnectedFingerprint = Object.entries(fingerprintConnections).find(entry => entry[1].clientId === client.id);
        if (disconnectedFingerprint) {
            const fingerprintId = disconnectedFingerprint[0];
            delete fingerprintConnections[fingerprintId];
            console.log(`Fingerprint with ID ${fingerprintId} disconnected`);
        }

        console.log(`Client disconnected`);
    });

    app.get('/api/fingerprintData', async (req, res) => {
        try {
            const fingerprintData = await FingerprintData.find()
                .sort({ timestamp: -1 })
                .limit(10);

            res.json(fingerprintData);
        } catch (error) {
            console.error('Error retrieving fingerprint data:', error);
            res.status(500).json({ error: 'Internal Server Error' });
        }
    });
});

const PORT = 3000;
server.listen(process.env.PORT || PORT, () => {
    console.log(`Example app listening at http://localhost:${PORT}`)
});

