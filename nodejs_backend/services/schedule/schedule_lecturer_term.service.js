const ScheduleModel = require("../../models/schedule/schedule.model");
const LecturerModel = require("../../models/lecturer.model");
const ModuleModel = require("../../models/module.model");
const SubjectModel = require("../../models/subject.model");
const RoomModel = require("../../models/room.model");

const ScheduleLecturerTermModel = require("../../models/schedule/schedule_lecturer_term.model");

class ScheduleLecturerTermService {
  static async getAllScheduleLecturerTerm(lecturerID) {
    try {
      const lecturer = await LecturerModel.findOne({ lecturerID: lecturerID })

      const modules = await ModuleModel.find({ lecturerID });
      // const classCode = modules.classCode;

      const scheduleLecturerTerms = [];

      for (const module of modules) {
        const { moduleID, classCode } = module;

        const scheduleModels = await ScheduleModel.find({ moduleID });


        for (const scheduleModel of scheduleModels) {
          const { dateStart, dateEnd, classRoomID, dayTerm } = scheduleModel;
          const roomName = await RoomModel.findOne({ classRoomID });
          
          const day = dayTerm[0].day;
          const time = dayTerm[0].time;

          const subjectID = module.subjectID;
          const subject = await SubjectModel.findOne({ subjectID });
          const subjectName = subject.subjectName;
          const numberOfCredits = subject.numberOfCredits

          const scheduleLecturerTerm = new ScheduleLecturerTermModel(day, time, moduleID, subjectName, roomName.roomName, classCode, dateStart, dateEnd, numberOfCredits);
          scheduleLecturerTerms.push(scheduleLecturerTerm);


        }
      }

      return scheduleLecturerTerms;
    } catch (err) {
      console.log(err);
    }
  }
}
module.exports = ScheduleLecturerTermService;