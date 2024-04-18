const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');



class AttendanceLecturerWeek {
    constructor(studentAttendance, numberOfOnTimeSessions, numberOfLateSessions, numberOfBreaksSessions) {
        // this.studentName = studentName;
        // this.attendance = attendance;
        this.studentAttendance = studentAttendance;
        this.numberOfOnTimeSessions = numberOfOnTimeSessions;
        this.numberOfLateSessions = numberOfLateSessions;
        this.numberOfBreaksSessions = numberOfBreaksSessions;
    }
}

module.exports = AttendanceLecturerWeek;