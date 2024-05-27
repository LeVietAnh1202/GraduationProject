const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

// Định nghĩa schema và model cho sinh viên
const studentSchema = new Schema({
    studentId: {
        type: String,
        required: [true, "Student ID is required"],
        unique: true,
    },
    studentName: {
        type: String,
        required: [true, "Student Name is required"],
    },
    classCode: {
        type: String,
        required: [true, "Class Code is required"],
    },
    specializationID: {
        type: String,
        required: [true, "specializationID is required"],
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
    // fingerprintID: {
    //     type: String,
    //     required: [true, "Fingerprint ID is required"],
    //     unique: true,
    // },
    avatar: {
        type: String,
        required: [true, "avatar is required"],
        unique: true,
    },
    video: {
        type: String,
        required: [true, "video is required"],
        unique: true,
    },
    NoAvatar: {
        type: Number,
    },
    NoFullImage: {
        type: Number,
    },
    NoCropImage: {
        type: Number,
    },
    NoVideo: {
        type: Number,
    },
}, { timestamps: true });

const Student = db.model('student', studentSchema);
module.exports = Student;