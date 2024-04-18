const RoomService = require('../services/room.service');

exports.createRoom = async (req, res, next) => {
  try {
    const { classRoomID, roomName } = req.body;
    const duplicate = await RoomService.getRoomByClassRoomID(classRoomID);
    if (duplicate) {
      return res.json({ status: true, success: 'ClassRoomID already exists' });
    }
    await RoomService.createRoom(classRoomID, roomName);
    res.json({ status: true, success: 'Create room successfully' });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};

exports.getAllRoom = async (req, res, next) => {
  try {
    const roomList = await RoomService.getAllRoom();
    res.json({ status: true, success: 'Get all rooms successfully', data: roomList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};