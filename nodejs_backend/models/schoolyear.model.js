const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const semesterSchema = new Schema({
  semesterID: {
    type: String,
    required: true,
    unique: true,
  },
  semesterName: {
    type: String,
    required: true,
  },
});

const schoolyearSchema = new Schema({
  schoolYearID: {
    type: String,
    required: true,
    unique: true,
  },
  schoolYearName: {
    type: String,
    required: true,
  },
  semesters: [semesterSchema],
}, { timestamps: true });

const Schoolyear = db.model('schoolyear', schoolyearSchema);
module.exports = Schoolyear;