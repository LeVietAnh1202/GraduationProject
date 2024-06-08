const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');



class AttendanceLecturerWeek {
    constructor(studentAttendance, time) {
        this.studentAttendance = studentAttendance;
        this.time = time;
    }
}

module.exports = AttendanceLecturerWeek;