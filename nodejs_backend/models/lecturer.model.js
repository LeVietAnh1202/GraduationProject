const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

// Định nghĩa schema và model cho sinh viên
const lecturerSchema = new Schema({
    lecturerID: {
        type: String,
        required: [true, "Student ID is required"],
        unique: true,
    },
    lecturerName: {
        type: String,
        required: [true, "Student Name is required"],
    },
    gender: {
        type: String,
        required: [true, "Gender is required"],
        enum: ['Nam', 'Nữ'],
    },
    birthDate: {
        type: Date,
        required: [true, "Birth Date is required"],
    },
}, { timestamps: true });

const Lecturer = db.model('lecturer', lecturerSchema);
module.exports = Lecturer;