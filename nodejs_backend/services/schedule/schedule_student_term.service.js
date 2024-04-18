const ScheduleModel = require("../../models/schedule/schedule.model");
const LecturerModel = require("../../models/lecturer.model");
const ModuleModel = require("../../models/module.model");
const StudentModel = require("../../models/student.model");
const SubjectModel = require("../../models/subject.model");
const RoomModel = require("../../models/room.model");

const ScheduleStudentTermModel = require("../../models/schedule/schedule_student_term.model");

// class ScheduleStudentWeekService {
//     // static async createSchedule(scheduleID, moduleID, dateStart, dateEnd, details) {
//     //     try {
//     //         const createSchedule = new ScheduleStudentWeekModel({ scheduleID, moduleID, dateStart, dateEnd, details });
//     //         return await createSchedule.save();
//     //     } catch (err) {
//     //         throw err;
//     //     }
//     // }

//     // static async getScheduleStudentWeekByScheduleID(scheduleID) {
//     //     try {
//     //         return await ScheduleStudentWeekModel.findOne({ scheduleID });
//     //     } catch (err) {
//     //         console.log(err);
//     //     }
//     // }

//     static async getAllScheduleStudentWeek(studentID) {
//         try {
//             // return await ScheduleStudentWeekModel.find();

//             scheduleModel = await ScheduleModel.findOne(studentID);

//             lecturerModel = await LecturerModel.find();




//             const scheduleStudentWeek = new ScheduleStudentWeekModel({ day, time, moduleID, subjectName, roomName, lecturerName, week, dateStart, dateEnd });

//             return scheduleStudentWeek;
//         } catch (err) {
//             console.log(err);
//         }
//     }
// }


class ScheduleStudentTermService {
  static async getAllScheduleStudentTerm(studentId) {
    try {
      const student = await StudentModel.findOne({ studentId: studentId });
      const classCode = student.classCode;
      console.log("classCode get :" + classCode);

      const modules = await ModuleModel.find({ classCode });

      const scheduleStudentTerms = [];

      for (const module of modules) {
        const { moduleID, lecturerId, } = module;

        const scheduleModels = await ScheduleModel.find({ moduleID });
        const lecturer = await LecturerModel.findOne({ lecturerId });

        for (const scheduleModel of scheduleModels) {
          const { details, dateStart, dateEnd, classRoomID, dayTerm } = scheduleModel;
          const roomName = await RoomModel.findOne({ classRoomID });
          console.log("dayTerm.day: " + dayTerm)
          const day = dayTerm[0].day;
          const time = dayTerm[0].time;
          console.log("dayTerm.day: " + day)
          console.log("dayTerm.Time: " + time)

          const subjectID = module.subjectID;
          const subject = await SubjectModel.findOne({ subjectID });
          const subjectName = subject.subjectName;
          const numberOfCredits = subject.numberOfCredits

          const lecturerName = lecturer.lecturerName;

          const scheduleStudentTerm = new ScheduleStudentTermModel(day, time, moduleID, subjectName, roomName.roomName, lecturerName, dateStart, dateEnd, numberOfCredits);
          scheduleStudentTerms.push(scheduleStudentTerm);


        }
      }

      return scheduleStudentTerms;
    } catch (err) {
      console.log(err);
    }
  }
}
module.exports = ScheduleStudentTermService;