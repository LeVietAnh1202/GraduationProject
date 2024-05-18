const ModuleModel = require('../models/module.model');

class ModuleService {
  static async createModule(moduleID, subjectID, listStudentID, lecturerID, semesterID) {
    try {
      const createModule = new ModuleModel({ moduleID, subjectID, listStudentID, lecturerID, semesterID });
      return await createModule.save();
    } catch (err) {
      throw err;
    }
  }

  static async getModuleByModuleID(moduleID) {
    try {
      return await ModuleModel.findOne({ moduleID });
    } catch (err) {
      console.log(err);
    }
  }
  static async getModuleBySemesterID(semesterID) {
    try {
      return await ModuleModel.findOne({ semesterID });
    } catch (err) {
      console.log(err);
    }
  }

  static async getAllModule() {
    try {
      return await ModuleModel.find();
    } catch (err) {
      console.log(err);
    }
  }
}

module.exports = ModuleService;