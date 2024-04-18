const ScheduleModel = require("../../models/schedule/schedule.model");
const LecturerModel = require("../../models/lecturer.model");
const ModuleModel = require("../../models/module.model");
const StudentModel = require("../../models/student.model");
const SubjectModel = require("../../models/subject.model");
const AttendanceModel = require("../../models/attendance.model");
const RoomModel = require("../../models/room.model");


const ScheduleStudentWeekModel = require("../../models/schedule/schedule_student_week.model");

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


class ScheduleStudentWeekService {
  static async getAllScheduleStudentWeek(studentId) {
    try {
      const student = await StudentModel.findOne({ studentId: studentId });
      console.log("studentID get :" + studentId);
      const classCode = student.classCode;
      console.log("classCode get :" + classCode);

      const modules = await ModuleModel.find({ classCode });

      const scheduleStudentWeeks = [];

      for (const module of modules) {
        console.log("module get :" + module);
        const { moduleID, lecturerId } = module;

        const scheduleModels = await ScheduleModel.find({ moduleID });
        const lecturer = await LecturerModel.findOne({ lecturerId });
        console.log("lecturer get :" + lecturer);

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
              const attendance = await AttendanceModel.findOne({ studentId: studentId, dayID: dayID });
              const subjectName = subject.subjectName;
              const lecturerName = lecturer.lecturerName;

              const scheduleStudentWeek = new ScheduleStudentWeekModel(day, time, moduleID, subjectName, roomName.roomName, lecturerName, week.week, weekTimeStart, weekTimeEnd, dayID, attendance?.attendance);
              scheduleStudentWeeks.push(scheduleStudentWeek);
            }
          }
        }
      }

      return scheduleStudentWeeks;
    } catch (err) {
      console.log(err);
    }
  }
}
module.exports = ScheduleStudentWeekService;