const RoomModel = require('../models/room.model');

class RoomService {
  static async createRoom(classRoomID, roomName) {
    try {
      const newRoom = new RoomModel({ classRoomID, roomName });
      return await newRoom.save();
    } catch (err) {
      throw err;
    }
  }

  static async getRoomByClassRoomID(classRoomID) {
    try {
      return await RoomModel.findOne({ classRoomID });
    } catch (err) {
      console.log(err);
    }
  }

  static async getAllRoom() {
    try {
      return await RoomModel.find();
    } catch (err) {
      console.log(err);
    }
  }
}

module.exports = RoomService;