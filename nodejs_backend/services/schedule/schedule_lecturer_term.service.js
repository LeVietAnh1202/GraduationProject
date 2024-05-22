const ScheduleModel = require("../../models/schedule/schedule.model");
const LecturerModel = require("../../models/lecturer.model");
const ModuleModel = require("../../models/module.model");
const SubjectModel = require("../../models/subject.model");
const RoomModel = require("../../models/room.model");

const ScheduleLecturerTermModel = require("../../models/schedule/schedule_lecturer_term.model");

class ScheduleLecturerTermService {
  // static async getAllScheduleLecturerTerm(lecturerID) {
  //   try {
  //     const lecturer = await LecturerModel.findOne({ lecturerID: lecturerID })

  //     const modules = await ModuleModel.find({ lecturerID });
  //     // const classCode = modules.classCode;

  //     const scheduleLecturerTerms = [];

  //     for (const module of modules) {
  //       const { moduleID, classCode } = module;

  //       const scheduleModels = await ScheduleModel.find({ moduleID });


  //       for (const scheduleModel of scheduleModels) {
  //         const { dateStart, dateEnd, classRoomID, dayTerm } = scheduleModel;
  //         const roomName = await RoomModel.findOne({ classRoomID });

  //         const day = dayTerm[0].day;
  //         const time = dayTerm[0].time;

  //         const subjectID = module.subjectID;
  //         const subject = await SubjectModel.findOne({ subjectID });
  //         const subjectName = subject.subjectName;
  //         const numberOfCredits = subject.numberOfCredits

  //         const scheduleLecturerTerm = new ScheduleLecturerTermModel(day, time, moduleID, subjectName, roomName.roomName, classCode, dateStart, dateEnd, numberOfCredits);
  //         scheduleLecturerTerms.push(scheduleLecturerTerm);


  //       }
  //     }

  //     return scheduleLecturerTerms;
  //   } catch (err) {
  //     console.log(err);
  //   }
  // }
  //}
  static async getAllScheduleLecturerTerm(lecturerID) {
    try {
      const lecturer = await LecturerModel.findOne({ lecturerID: lecturerID });
      if (!lecturer) {
        throw new Error(`Lecturer with ID ${lecturerID} not found`);
      }

      const modules = await ModuleModel.find({ lecturerID });
      if (!modules || modules.length === 0) {
        throw new Error(`No modules found for lecturer with ID ${lecturerID}`);
      }

      const scheduleLecturerTerms = [];

      for (const module of modules) {
        const { moduleID, classCode } = module;

        const scheduleModels = await ScheduleModel.find({ moduleID });
        if (!scheduleModels || scheduleModels.length === 0) {
          console.warn(`No schedules found for module with ID ${moduleID}`);
          continue;
        }

        for (const scheduleModel of scheduleModels) {
          const { dateStart, dateEnd, classRoomID, dayTerms } = scheduleModel;
          if (!dayTerms || dayTerms.length === 0) {
            console.warn(`No dayTerms found for schedule with ID ${scheduleModel._id}`);
            continue;
          }

          const room = await RoomModel.findOne({ classRoomID });
          if (!room) {
            console.warn(`Room with ID ${classRoomID} not found`);
            continue;
          }

          for (const dayTerm of dayTerms) {
            const { day, time, weekTimeStart, weekTimeEnd } = dayTerm;

            const subject = await SubjectModel.findOne({ subjectID: module.subjectID });
            if (!subject) {
              console.warn(`Subject with ID ${module.subjectID} not found`);
              continue;
            }
            const subjectName = subject.subjectName;
            const numberOfCredits = subject.numberOfCredits;

            const scheduleLecturerTerm = {
              day,
              time,
              moduleID,
              subjectName,
              roomName: room.roomName,
              classCode,
              dateStart,
              dateEnd,
              numberOfCredits,
              weekTimeStart,
              weekTimeEnd
            };
            scheduleLecturerTerms.push(scheduleLecturerTerm);
          }
        }
      }

      return scheduleLecturerTerms;
    } catch (err) {
      console.error(err);
      throw err;
    }
  }
}

module.exports = ScheduleLecturerTermService;