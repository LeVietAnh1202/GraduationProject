const ScheduleModel = require("../../models/schedule/schedule.model");
const ModuleModel = require("../../models/module.model");
const LecturerModel = require("../../models/lecturer.model");
const SubjectModel = require("../../models/subject.model");
const RoomModel = require("../../models/room.model");


const ScheduleLecturerWeekModel = require("../../models/schedule/schedule_lecturer_week.model");

// class ScheduleLecturerWeekService {
//     // static async createSchedule(scheduleID, moduleID, dateStart, dateEnd, details) {
//     //     try {
//     //         const createSchedule = new ScheduleLecturerWeekModel({ scheduleID, moduleID, dateStart, dateEnd, details });
//     //         return await createSchedule.save();
//     //     } catch (err) {
//     //         throw err;
//     //     }
//     // }

//     // static async getScheduleLecturerWeekByScheduleID(scheduleID) {
//     //     try {
//     //         return await ScheduleLecturerWeekModel.findOne({ scheduleID });
//     //     } catch (err) {
//     //         console.log(err);
//     //     }
//     // }

//     static async getAllScheduleLecturerWeek(studentID) {
//         try {
//             // return await ScheduleLecturerWeekModel.find();

//             scheduleModel = await ScheduleModel.findOne(studentID);

//             lecturerModel = await LecturerModel.find();




//             const scheduleLecturerWeek = new ScheduleLecturerWeekModel({ day, time, moduleID, subjectName, roomName, lecturerName, week, dateStart, dateEnd });

//             return scheduleLecturerWeek;
//         } catch (err) {
//             console.log(err);
//         }
//     }
// }


class ScheduleLecturerWeekService {
  static async getAllScheduleLecturerWeek(lecturerId) {
    try {
      const lecturer = await LecturerModel.findOne({ lecturerId: lecturerId });
      console.log("lecturerId get :" + lecturerId);

      const modules = await ModuleModel.find({ lecturerId });
      // const classCode = modules.classCode;

      const scheduleLecturerWeeks = [];

      for (const module of modules) {
        console.log("module get :" + module);
        const { moduleID, classCode } = module;

        const scheduleModels = await ScheduleModel.find({ moduleID });
        console.log("lecturer get :" + lecturerId);

        for (const scheduleModel of scheduleModels) {
          const { details, classRoomID } = scheduleModel;
          const roomName = await RoomModel.findOne({ classRoomID });

          for (const week of details) {
            const { weekDetails } = week;
            const weekTimeStart = week.weekTimeStart;
            const weekTimeEnd = week.weekTimeEnd;

            for (const weekDetail of weekDetails) {
              const { day, time, dayID } = weekDetail;

              const subjectID = module.subjectID;
              const subject = await SubjectModel.findOne({ subjectID });
              const subjectName = subject.subjectName;

              const scheduleLecturerWeek = new ScheduleLecturerWeekModel(day, time, moduleID, subjectName, roomName.roomName, classCode, week.week, weekTimeStart, weekTimeEnd, dayID);
              scheduleLecturerWeeks.push(scheduleLecturerWeek);
            }
          }
        }
      }

      return scheduleLecturerWeeks;
    } catch (err) {
      console.log(err);
    }
  }
}
module.exports = ScheduleLecturerWeekService;