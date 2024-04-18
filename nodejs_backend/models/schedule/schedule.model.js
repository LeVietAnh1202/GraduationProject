const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../../config/db');

const dayTermSchema = new Schema({
    day: {
        type: String,
        required: true,
    },
    time: {
        type: String,
        required: true,
    },
});

const weekDetailsSchema = new Schema({
    day: {
        type: String,
        required: true,
    },
    time: {
        type: String,
        required: true,
    },
    dayID: {
        type: String,
        required: true,
    },
});

const weekSchema = new Schema({
    week: {
        type: String,
        required: true,
    },
    weekTimeStart: {
        type: Date,
        required: true,
    },
    weekTimeEnd: {
        type: Date,
        required: true,
    },
    weekDetails: [weekDetailsSchema],
});

const scheduleSchema = new Schema({
    scheduleID: {
        type: String,
        required: true,
        unique: true,
    },
    moduleID: {
        type: String,

        required: true,
    },
    dayTerm: [dayTermSchema
    ],
    dateStart: {
        type: Date,
        required: true,
    },
    dateEnd: {
        type: Date,
        required: true,
    },
    details: [weekSchema],
    classRoomID: {
        type: String,
        required: true,
    },
}, { timestamps: true });

const Schedule = db.model('schedule', scheduleSchema);
module.exports = Schedule;