const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');

class AttendanceStudentByDayID {
    constructor(
        moduleID,
        roomName,
        lecturerName,
        subjectName,
        attendance,
        day,
        time
    ) {
        this.moduleID = moduleID;
        this.roomName = roomName;
        this.lecturerName = lecturerName;
        this.subjectName = subjectName;
        this.attendance = attendance;
        this.day = day;
        this.time = time;
    }
}

module.exports = AttendanceStudentByDayID;