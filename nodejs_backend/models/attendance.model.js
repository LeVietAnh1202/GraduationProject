const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const attendanceSchema = new Schema({
  studentId: {
    type: String,
    required: true,
  },
  dayID: {
    type: String,
    required: true,
  },
  attendance: {
    type: [String],
    required: true,
  },
}, { timestamps: true });

const Attendance = db.model('attendance', attendanceSchema);
module.exports = Attendance;