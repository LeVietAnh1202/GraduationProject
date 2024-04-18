const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const deviceSchema = new Schema({
  deviceID: {
    type: String,
    required: true,
    unique: true,
  },
  classRoomID: {
    type: String,
    required: true,
  },
}, { timestamps: true });

const Device = db.model('device', deviceSchema);
module.exports = Device;