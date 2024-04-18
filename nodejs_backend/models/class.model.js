const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const classSchema = new Schema({
  classCode: {
    type: String,
    required: true,
    unique: true,
  },
  className: {
    type: String,
    required: true,
  },
}, { timestamps: true });

const Class = db.model('class', classSchema);
module.exports = Class;