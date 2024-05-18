const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');


class ScheduleAdminTerm {
    constructor(day, time, moduleID, subjectName, lecturerName, roomName, dateStart, dateEnd, numberOfCredits) {
        this.day = day;
        this.time = time;
        this.moduleID = moduleID;
        this.subjectName = subjectName;
        this.lecturerName = lecturerName;
        this.roomName = roomName;
        this.dateStart = dateStart;
        this.dateEnd = dateEnd;
        this.numberOfCredits = numberOfCredits;
    }
}

module.exports = ScheduleAdminTerm;