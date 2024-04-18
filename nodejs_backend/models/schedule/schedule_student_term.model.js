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



class ScheduleStudentTerm {
    constructor(day, time, moduleID, subjectName, roomName, lecturerName, dateStart, dateEnd, numberOfCredits) {
        this.day = day;
        this.time = time;
        this.moduleID = moduleID;
        this.subjectName = subjectName;
        this.roomName = roomName;
        this.lecturerName = lecturerName;
        this.dateStart = dateStart;
        this.dateEnd = dateEnd;
        this.numberOfCredits = numberOfCredits;
    }
}

module.exports = ScheduleStudentTerm;