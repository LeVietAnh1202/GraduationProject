const ScheduleModel = require("../../models/schedule/schedule.model");
const ModuleModel = require("../../models/module.model");
const AttendanceModel = require("../../models/attendance.model");
const StudentModel = require("../../models/student.model");
const AttendanceStudentTermModel = require("../../models/attendance/attendance_student_term.model");

class AttendanceStudentTermService {
  static async getAllAttendanceStudentTerm(studentId, moduleID) {
    try {
      const studentPromise = StudentModel.findOne({ studentId }).exec();
      const scheduleModelsPromise = ScheduleModel.find({ moduleID }).exec();

      const [student, scheduleModels] = await Promise.all([studentPromise, scheduleModelsPromise]);

      if (student) {
        const attendances = [];
        let numberOfOnTimeSessions = 0;
        let numberOfLateSessions = 0;
        let numberOfBreaksSessions = 0;

        for (const scheduleModel of scheduleModels) {
          const { details } = scheduleModel;

          for (const week of details) {
            const { weekDetails } = week;
            const weekTimeStart = new Date(week.weekTimeStart);

            for (const weekDetail of weekDetails) {
              const { dayID, day } = weekDetail;
              const numberOfDays = parseInt(day, 10);
              weekTimeStart.setDate(weekTimeStart.getDate() + numberOfDays - 2);
              const weekTimeStartStr = weekTimeStart.toISOString();

              const attendancePromise = AttendanceModel.findOne({ studentId: student.studentId, dayID }).exec();

              const attendance = await attendancePromise;
              const attendanceValue = attendance ? attendance.attendance : null;

              if (attendanceValue === 0) {
                numberOfBreaksSessions++;
              } else if (attendanceValue === 1) {
                numberOfLateSessions++;
              } else if (attendanceValue === 2) {
                numberOfOnTimeSessions++;
              }

              attendances.push({ [weekTimeStartStr]: attendanceValue });
            }
          }
        }
        const attendanceStudentTerm = new AttendanceStudentTermModel(
          student.studentName,
          attendances,
          numberOfOnTimeSessions,
          numberOfLateSessions,
          numberOfBreaksSessions
        );

        return attendanceStudentTerm;
      }

      return null;
    } catch (err) {
      console.log(err);
    }
  }
}

module.exports = AttendanceStudentTermService;