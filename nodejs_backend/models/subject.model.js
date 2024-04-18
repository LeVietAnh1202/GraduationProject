const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const subjectSchema = new Schema({
    subjectID: {
        type: String,
        required: true,
        unique: true,
    },
    subjectName: {
        type: String,
        required: true,
    },
    numberOfCredits: {
        type: Number,
        required: true,
    },
    numberOfLessons: {
        type: Number,
        required: true,
    },
}, { timestamps: true });

const Subject = db.model('subject', subjectSchema);
module.exports = Subject;