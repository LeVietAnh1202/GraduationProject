const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');


class ModuleTermByLecturerIDModel {
    constructor(moduleID, subjectName, roomName, lecturerName, dateStart, dateEnd, numberOfCredits) {
        this.moduleID = moduleID;
        this.subjectName = subjectName;
        this.roomName = roomName;
        this.lecturerName = lecturerName;
        this.dateStart = dateStart;
        this.dateEnd = dateEnd;
        this.numberOfCredits = numberOfCredits;
    }
}

module.exports = ModuleTermByLecturerIDModel;