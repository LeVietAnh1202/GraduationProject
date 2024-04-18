const ClassModel = require('../models/class.model');

class ClassService {
  static async createClass(classCode, className) {
    try {
      const newClass = new ClassModel({ classCode, className });
      return await newClass.save();
    } catch (err) {
      throw err;
    }
  }

  static async getClassByClassCode(classCode) {
    try {
      return await ClassModel.findOne({ classCode });
    } catch (err) {
      console.log(err);
    }
  }

  static async getAllClass() {
    try {
      return await ClassModel.find();
    } catch (err) {
      console.log(err);
    }
  }
}

module.exports = ClassService;