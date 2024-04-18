const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');


class ScheduleLecturerTerm {
    constructor(day, time, moduleID, subjectName, roomName, classCode, dateStart, dateEnd, numberOfCredits) {
        this.day = day;
        this.time = time;
        this.moduleID = moduleID;
        this.subjectName = subjectName;
        this.roomName = roomName;
        this.classCode = classCode;
        this.dateStart = dateStart;
        this.dateEnd = dateEnd;
        this.numberOfCredits = numberOfCredits;
    }
}

module.exports = ScheduleLecturerTerm;