const DeviceModel = require('../models/device.model');

class DeviceService {
  static async createDevice(deviceID, classRoomID) {
    try {
      const newDevice = new DeviceModel({ deviceID, classRoomID });
      return await newDevice.save();
    } catch (err) {
      throw err;
    }
  }

  static async getDeviceByDeviceID(deviceID) {
    try {
      return await DeviceModel.findOne({ deviceID });
    } catch (err) {
      console.log(err);
    }
  }

  static async getAllDevice() {
    try {
      return await DeviceModel.find();
    } catch (err) {
      console.log(err);
    }
  }
}

module.exports = DeviceService;