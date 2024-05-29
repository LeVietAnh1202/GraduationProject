const ScheduleModel = require("../models/schedule/schedule.model");
const LecturerModel = require("../models/lecturer.model");
const ModuleModel = require("../models/module.model");
const SubjectModel = require("../models/subject.model");
const RoomModel = require("../models/room.model");
const ModuleTermByLecturerIDModel = require('../models/module_term_by_lecturerID.model');

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

  static async getAllModuleTermByLecturerID(_lecturerID, semesterID, studentId) {
    try {
      // Tìm tất cả các module của giảng viên trong học kỳ hiện tại
      var modules;
      if (_lecturerID === "") {
        modules = await ModuleModel.find({ listStudentID: studentId, semesterID });
      }
      else if (studentId === "") {
        modules = await ModuleModel.find({ lecturerID: _lecturerID, semesterID });
      }

      if (!modules || modules.length === 0) {
        console.warn(`No modules found for lecturer with ID ${_lecturerID} and semester ID ${semesterID}`);
        return [];
      }

      const moduleTerms = [];

      for (const module of modules) {
        const { moduleID, lecturerID } = module;

        // Tìm tất cả các lịch trình của module
        const scheduleModels = await ScheduleModel.find({ moduleID });
        if (!scheduleModels || scheduleModels.length === 0) {
          console.warn(`No schedules found for module with ID ${moduleID}`);
          continue;
        }

        // // Tìm thông tin giảng viên
        // const lecturer = await LecturerModel.findOne({ lecturerID });
        // if (!lecturer) {
        //   console.warn(`Lecturer with ID ${lecturerID} not found`);
        //   continue;
        // }
        const lecturer = await LecturerModel.findOne({ lecturerID: studentId === "" ? _lecturerID : lecturerID });
        const lecturerName = lecturer.lecturerName;
        for (const scheduleModel of scheduleModels) {
          const { dateStart, dateEnd, classRoomID, dayTerms } = scheduleModel;

          // Tìm thông tin phòng học
          const room = await RoomModel.findOne({ classRoomID });
          if (!room) {
            console.warn(`Room with ID ${classRoomID} not found`);
            continue;
          }

          // Tìm thông tin môn học
          const subject = await SubjectModel.findOne({ subjectID: module.subjectID });

          const subjectName = subject.subjectName;
          const numberOfCredits = subject.numberOfCredits;

          // Tạo đối tượng ScheduleAdminTermModel
          const moduleTerm = new ModuleTermByLecturerIDModel(
            moduleID,
            subjectName,
            room.roomName,
            lecturerName,
            dateStart,
            dateEnd,
            numberOfCredits,
            // weekTimeStart,
            // weekTimeEnd
          );
          moduleTerms.push(moduleTerm);

        }
      }
      return moduleTerms;
    } catch (err) {
      console.error(err);
      throw err; // Ném lỗi để xử lý ở cấp cao hơn nếu cần thiết
    }
  }
}

module.exports = ModuleService;