const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');

class AttendanceStudentTerm {
    constructor(studentName, dateList, numberOfOnTimeSessions, numberOfLateSessions, numberOfBreaksSessions) {
        this.studentName = studentName;
        this.dateList = dateList;
        this.numberOfOnTimeSessions = numberOfOnTimeSessions;
        this.numberOfLateSessions = numberOfLateSessions;
        this.numberOfBreaksSessions = numberOfBreaksSessions;
    }
}

module.exports = AttendanceStudentTerm;