const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const specializationsSchema = new Schema({
    specializationID: {
        type: String,
        required: true,
        unique: true,
    },
    specializationName: {
        type: String,
        required: true,
    },
});

const majorsSchema = new Schema({
    majorID: {
        type: String,
        required: true,
        unique: true,
    },
    majorName: {
        type: String,
        required: true,
    },
    specializations: [specializationsSchema],
});

const facultySchema = new Schema({
    facultyID: {
        type: String,
        required: true,
        unique: true,
    },
    facultyName: {
        type: String,
        required: true,
    },
    majors: [majorsSchema],
}, { timestamps: true });

const Faculty = db.model('faculty', facultySchema);
module.exports = Faculty;