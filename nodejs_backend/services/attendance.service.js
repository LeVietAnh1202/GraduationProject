const AttendanceModel = require('../models/attendance.model');

class AttendanceService {
  static async createAttendance(studentId, scheduleID, attendance) {
    try {
      const newAttendance = new AttendanceModel({ studentId, scheduleID, attendance });
      return await newAttendance.save();
    } catch (err) {
      throw err;
    }
  }

  static async getAttendanceByStudentId(studentId) {
    try {
      return await AttendanceModel.findOne({ studentId });
    } catch (err) {
      console.log(err);
    }
  }

  static async getAllAttendance() {
    try {
      return await AttendanceModel.find();
    } catch (err) {
      console.log(err);
    }
  }
}

module.exports = AttendanceService;