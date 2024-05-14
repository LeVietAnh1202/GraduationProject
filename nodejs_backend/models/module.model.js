const mongoose = require('mongoose');
const { Schema } = mongoose;
const db = require('../config/db');

const moduleSchema = new Schema({
  moduleID: {
    type: String,
    required: true,
    unique: true,
  },
  subjectID: {
    type: String,
    required: true,
  },
  listStudentID: {
    type: [String],  
    required: true,  
  },
  lecturerId: {
    type: String,
    required: true,
  },
}, { timestamps: true });

const Module = db.model('module', moduleSchema);
module.exports = Module;