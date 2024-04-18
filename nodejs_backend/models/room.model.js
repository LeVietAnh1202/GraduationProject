const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const roomSchema = new Schema({
  classRoomID: {
    type: String,
    required: true,
    unique: true,
  },
  roomName: {
    type: String,
    required: true,
  },
}, { timestamps: true });

const Room = db.model('room', roomSchema);
module.exports = Room;