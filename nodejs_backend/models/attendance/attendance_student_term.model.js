const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');

class AttendanceStudentTerm {
    constructor(studentName, dateList, NoImagesValid, numberOfLessons) {
        this.studentName = studentName;
        this.dateList = dateList;
        this.NoImagesValid = NoImagesValid;
        this.numberOfLessons = numberOfLessons;
    }
}

module.exports = AttendanceStudentTerm;