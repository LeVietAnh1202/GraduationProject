const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');


class ModuleTermByLecturerIDModel {
    constructor(moduleID, subjectName, roomName, dateStart, dateEnd, numberOfCredits, weekTimeStart, weekTimeEnd) {
        this.moduleID = moduleID;
        this.subjectName = subjectName;
        this.roomName = roomName;
        this.dateStart = dateStart;
        this.dateEnd = dateEnd;
        this.numberOfCredits = numberOfCredits;
        this.weekTimeStart = weekTimeStart;
        this.weekTimeEnd = weekTimeEnd;
    }
}

module.exports = ModuleTermByLecturerIDModel;