const ScheduleModel = require("../../models/schedule/schedule.model");

const ModuleModel = require("../../models/module.model");
const AttendanceModel = require("../../models/attendance.model");

const StudentModel = require("../../models/student.model");

const AttendanceLecturerTermModel = require("../../models/attendance/attendance_lecturer_term.model");

class AttendanceLecturerTermService {
  static async getAllAttendanceLecturerTerm(lecturerID, moduleID) {

    try {
      const modulePromise = ModuleModel.findOne({ lecturerID, moduleID }).exec();
      const classCodePromise = modulePromise.then(module => module.classCode);
      const studentsPromise = classCodePromise.then(classCode => StudentModel.find({ classCode }).exec());
      const scheduleModelsPromise = ScheduleModel.find({ moduleID }).exec();

      const [students, scheduleModels] = await Promise.all([studentsPromise, scheduleModelsPromise]);
      const attendanceLecturerTerms = [];

      for (const student of students) {
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

                  console.log(studentName + ' ' + dayID + ' currentTime' + currentTime);
                  console.log(studentName + ' ' + dayID + ' afterTimeStartSession' + afterTimeStartSession);
                  console.log(studentName + ' ' + dayID + ' (currentTime > afterTimeStartSession)' + (currentTime > afterTimeStartSession));
                  const attendanceValue = attendance ? attendance.attendance : ((currentTime > afterTimeStartSession) ? 0 : null);
                  console.log(studentName + ' ' + dayID + ' attendanceValue' + attendanceValue);
                  if (attendanceValue === 0) {
                    numberOfBreaksSessions++;
                  } else if (attendanceValue === 1) {
                    numberOfLateSessions++;
                  } else if (attendanceValue === 2) {
                    numberOfOnTimeSessions++;
                  }

                  return { [weekTimeStartStr]: attendanceValue };
                })
              );
              // attendances.push(
              //   attendancePromise.then(attendance => {
              //     const sessionStartTime = new Date(schedule['sessionStartTime']);
              //     const sessionEndTime = new Date(schedule['sessionEndTime']);
              //     const sessionEndTimePlus30Min = new Date(sessionEndTime.getTime() + 30 * 60000); // Add 30 minutes to sessionEndTime

              //     // Compare current time with sessionEndTimePlus30Min and handle attendance value accordingly
              //     const currentTime = new Date();
              //     let attendanceValue;

              //     if (attendance === null) {
              //       if (currentTime > sessionEndTimePlus30Min) {
              //         attendanceValue = 0; // Attendance value is 0 if current time is greater than sessionEndTimePlus30Min
              //       } else {
              //         attendanceValue = null; // Attendance value remains null if current time is less than or equal to sessionEndTimePlus30Min
              //       }
              //     } else {
              //       attendanceValue = attendance.attendance;

              //       if (attendanceValue === 0) {
              //         numberOfBreaksSessions++;
              //       } else if (attendanceValue === 1) {
              //         numberOfLateSessions++;
              //       } else if (attendanceValue === 2) {
              //         numberOfOnTimeSessions++;
              //       }
              //     }

              //     return { [weekTimeStartStr]: attendanceValue };
              //   })
              // );
            }
          }
        }

        const studentName = student.studentName;
        const attendanceLecturerTerm = new AttendanceLecturerTermModel(studentName, await Promise.all(attendances), numberOfOnTimeSessions, numberOfLateSessions, numberOfBreaksSessions);
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