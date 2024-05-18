const ScheduleModel = require("../../models/schedule/schedule.model");
const LecturerModel = require("../../models/lecturer.model");
const ModuleModel = require("../../models/module.model");
const SubjectModel = require("../../models/subject.model");
const RoomModel = require("../../models/room.model");

const ScheduleAdminTermModel = require("../../models/schedule/schedule_admin_term.model");

class ScheduleAdminTermService {
  static async getAllScheduleAdminTerm(lecturerID, subjectID, semesterID) {
    try {
      console.log('semesterID service: ' + semesterID)
      const modules = await ModuleModel.find({ lecturerID: lecturerID, semesterID: semesterID, subjectID: subjectID  });
      console.log(modules)

      const scheduleAdminTerms = [];

      for (const module of modules) {
        const { moduleID } = module;

        const scheduleModels = await ScheduleModel.find({ moduleID });
        const lecturer = await LecturerModel.findOne({ lecturerID });
        const lecturerName = lecturer.lecturerName;

        for (const scheduleModel of scheduleModels) {
          const { dateStart, dateEnd, classRoomID, dayTerms } = scheduleModel;
          const roomName = await RoomModel.findOne({ classRoomID });
          for (const dayTerm of dayTerms) {
            const day = dayTerm.day;
            const time = dayTerm.time;
            const subject = await SubjectModel.findOne({ subjectID });
            const subjectName = subject.subjectName;
            const numberOfCredits = subject.numberOfCredits;

            const scheduleAdminTerm = new ScheduleAdminTermModel(day, time, moduleID, subjectName, lecturerName, roomName.roomName, dateStart, dateEnd, numberOfCredits);
            scheduleAdminTerms.push(scheduleAdminTerm);
          }
        }
      }

      return scheduleAdminTerms;
    } catch (err) {
      console.log(err);
    }
  }
}
module.exports = ScheduleAdminTermService;