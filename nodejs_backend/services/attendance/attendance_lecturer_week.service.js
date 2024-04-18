const ScheduleModel = require("../../models/schedule/schedule.model");

const ModuleModel = require("../../models/module.model");
const AttendanceModel = require("../../models/attendance.model");

const StudentModel = require("../../models/student.model");

const AttendanceLecturerWeekModel = require("../../models/attendance/attendance_lecturer_week.model");

class AttendanceLecturerWeekService {
  static async getAllAttendanceLecturerWeek(lecturerId, dayID) {
    try {
      const studentAttendances = [];

      const attendances = await AttendanceModel.find({ dayID }).exec();
      
      let numberOfOnTimeSessions = 0;
      let numberOfLateSessions = 0;
      let numberOfBreaksSessions = 0;
      for (const attendanceItem of attendances) {

        const attendanceValue = attendanceItem ? attendanceItem.attendance : null;

        if (attendanceValue === 0) {
          numberOfBreaksSessions++;
        } else if (attendanceValue === 1) {
          numberOfLateSessions++;
        } else if (attendanceValue === 2) {
          numberOfOnTimeSessions++;
        }

        const { studentId } = attendanceItem;
        const student =  await StudentModel.findOne({ studentId }).exec();;
        const studentName = student.studentName;
        studentAttendances.push({[studentName]: attendanceValue})

      }
      const attendanceLecturerTerm = new AttendanceLecturerWeekModel(studentAttendances, numberOfOnTimeSessions, numberOfLateSessions, numberOfBreaksSessions);

      return attendanceLecturerTerm;
    } catch (err) {
      console.log(err);
    }
  }
}
module.exports = AttendanceLecturerWeekService;