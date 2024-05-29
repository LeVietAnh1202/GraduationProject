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
        var NoImagesValid = 0;
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
              const studentId = student.studentId;

              console.log(studentId)
              console.log(dayID)
              const attendancePromise = AttendanceModel.findOne({ studentId, dayID }).exec();

              const attendance = await attendancePromise;
              console.log('attendance')
              console.log(attendance)
              const attendanceImages = attendance ? attendance.attendance : [];
              const NoImages = attendanceImages.length;
              NoImagesValid += NoImages;

              attendances.push({ [weekTimeStartStr]: { attendanceImages: attendanceImages, NoImages: NoImages } });
            }
          }
        }
        const attendanceStudentTerm = new AttendanceStudentTermModel(
          student.studentName,
          attendances,
          NoImagesValid
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