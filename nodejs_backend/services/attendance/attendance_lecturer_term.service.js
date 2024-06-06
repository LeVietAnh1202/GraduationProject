const ScheduleModel = require("../../models/schedule/schedule.model");

const ModuleModel = require("../../models/module.model");
const SubjectModel = require("../../models/subject.model");
const AttendanceModel = require("../../models/attendance.model");

const StudentModel = require("../../models/student.model");

const AttendanceLecturerTermModel = require("../../models/attendance/attendance_lecturer_term.model");

class AttendanceLecturerTermService {
  static async getAllAttendanceLecturerTerm(lecturerID, moduleID) {

    try {
      const module = await ModuleModel.findOne({ moduleID: moduleID });
      const listStudentID = module.listStudentID;
      const subjectID = module.subjectID;
      const subject = await SubjectModel.findOne({ subjectID });
      const numberOfLessons = subject.numberOfLessons;
      const students = await StudentModel.find({ studentId: { $in: listStudentID } });
      const scheduleModelsPromise = ScheduleModel.find({ moduleID }).exec();

      const [scheduleModels] = await Promise.all([scheduleModelsPromise]);
      const attendanceLecturerTerms = [];

      for (const student of students) {
        const attendances = [];
        var NoImagesValid = 0;
        for (const scheduleModel of scheduleModels) {
          const { details } = scheduleModel;

          for (const week of details) {
            const { weekDetails } = week;
            const weekTimeStart = new Date(week.weekTimeStart);

            for (const weekDetail of weekDetails) {
              const { dayID, day, time } = weekDetail;
              const numberOfDays = parseInt(day, 10);

              const [hours, minutes] = calculateTime(time).split(':');
              weekTimeStart.setDate(weekTimeStart.getDate() + numberOfDays - 2);
              weekTimeStart.setHours(hours);
              weekTimeStart.setMinutes(minutes);

              const weekTimeStartStr = weekTimeStart.toISOString();
              const timeStartSession = new Date(weekTimeStart);
              const afterTimeStartSession = new Date(timeStartSession.getTime() + 30 * 60000);
              const currentTime = new Date(global.currentTime)

              const attendancePromise = AttendanceModel.findOne({ studentId: student.studentId, dayID }).exec();

              attendances.push(
                attendancePromise.then(attendance => {
                  const attendanceImages = attendance ? attendance.attendance : [];
                  const NoImages = attendanceImages.length;
                  NoImagesValid += NoImages;

                  return { [weekTimeStartStr]: { attendanceImages: attendanceImages, NoImages: NoImages, time: time, dayID: dayID } };
                })
              );
            }
          }
        }

        const studentName = student.studentName;
        const attendanceLecturerTerm = new AttendanceLecturerTermModel(studentName, await Promise.all(attendances), NoImagesValid,
          numberOfLessons);
        attendanceLecturerTerms.push(attendanceLecturerTerm);
      }
      return attendanceLecturerTerms;
    } catch (err) {
      console.log(err);
    }
  }
}

function calculateTime(time) {
  const [startHour, endHour] = time.split('-').map(Number);
  var startTime = '';
  if (startHour == '1') startTime = '07:15'
  if (startHour == '8') startTime = '13:35'
  return startTime;
}

module.exports = AttendanceLecturerTermService;