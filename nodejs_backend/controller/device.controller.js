const DeviceService = require('../services/device.service');

exports.createDevice = async (req, res, next) => {
    try {
        const { deviceID, classRoomID } = req.body;
        const duplicate = await DeviceService.getDeviceByDeviceID(deviceID);
        if (duplicate) {
            return res.json({ status: true, success: 'DeviceID already exists' });
        }
        await DeviceService.createDevice(deviceID, classRoomID);
        res.json({ status: true, success: 'Create device successfully' });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

exports.getAllDevice = async (req, res, next) => {
    try {
        const deviceList = await DeviceService.getAllDevice();
        res.json({ status: true, success: 'Get all devices successfully', data: deviceList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};