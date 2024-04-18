const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');

// const scheduleStudentWeekSchema = new Schema({
//     day: {
//         type: String,
//         required: true,
//     },
//     time: {
//         type: String,
//         required: true,
//     },
//     moduleID: {
//         type: String,
//         required: true,
//     },
//     subjectName: {
//         type: String,
//         required: true,
//     },
//     roomName: {
//         type: String,
//         required: true,
//     },
//     lecturerName: {
//         type: String,
//         required: [true, "Lecturer Name is required"],
//     },
//     week: {
//         type: String,
//         required: true,
//     },
//     dateStart: {
//         type: Date,
//         required: true,
//     },
//     dateEnd: {
//         type: Date,
//         required: true,
//     },
// }, { timestamps: true });

// const ScheduleStudentWeek = db.model('scheduleStudentWeek', scheduleStudentWeekSchema);



class AttendanceLecturerTerm {
    constructor(studentName, dateList, numberOfOnTimeSessions, numberOfLateSessions, numberOfBreaksSessions) {
        this.studentName = studentName;
        this.dateList = dateList;
        this.numberOfOnTimeSessions = numberOfOnTimeSessions;
        this.numberOfLateSessions = numberOfLateSessions;
        this.numberOfBreaksSessions = numberOfBreaksSessions;
    }
}

module.exports = AttendanceLecturerTerm;