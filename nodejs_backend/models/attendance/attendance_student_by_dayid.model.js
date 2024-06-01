const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');

class AttendanceStudentByDayID {
    constructor(
        moduleID,
        classRoomID,
        lecturerName,
        subjectName,
        attendance,
        day,
        time
    ) {
        this.moduleID = moduleID;
        this.classRoomID = classRoomID;
        this.lecturerName = lecturerName;
        this.subjectName = subjectName;
        this.attendance = attendance;
        this.day = day;
        this.time = time;
    }
}

module.exports = AttendanceStudentByDayID;