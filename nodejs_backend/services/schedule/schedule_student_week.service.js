const ScheduleModel = require("../../models/schedule/schedule.model");
const LecturerModel = require("../../models/lecturer.model");
const ModuleModel = require("../../models/module.model");
const StudentModel = require("../../models/student.model");
const SubjectModel = require("../../models/subject.model");
const AttendanceModel = require("../../models/attendance.model");
const RoomModel = require("../../models/room.model");


const ScheduleStudentWeekModel = require("../../models/schedule/schedule_student_week.model");


class ScheduleStudentWeekService {
  static async getAllScheduleStudentWeek(studentId) {
    console.time('ExecutionTime');
    try {
      const modules = await ModuleModel.find({ listStudentID: studentId });
      if (modules.length === 0) throw new Error('No modules found for the student');

      const moduleIDs = modules.map(module => module.moduleID);
      const lecturerIDs = modules.map(module => module.lecturerID);
      const subjectIDs = modules.map(module => module.subjectID);

      const [schedules, lecturers, subjects, attendances] = await Promise.all([
        ScheduleModel.find({ moduleID: { $in: moduleIDs } }),
        LecturerModel.find({ lecturerID: { $in: lecturerIDs } }),
        SubjectModel.find({ subjectID: { $in: subjectIDs } }),
        AttendanceModel.find({ studentId })
      ]);

      const roomIDs = schedules.map(schedule => schedule.classRoomID);
      const rooms = await RoomModel.find({ classRoomID: { $in: roomIDs } });

      // Create a map for quick lookup
      const lecturerMap = lecturers.reduce((acc, lecturer) => {
        acc[lecturer.lecturerID] = lecturer.lecturerName;
        return acc;
      }, {});

      const subjectMap = subjects.reduce((acc, subject) => {
        acc[subject.subjectID] = subject.subjectName;
        return acc;
      }, {});

      const roomMap = rooms.reduce((acc, room) => {
        acc[room.classRoomID] = room.roomName;
        return acc;
      }, {});

      const attendanceMap = attendances.reduce((acc, attendance) => {
        acc[attendance.dayID] = attendance.attendance;
        return acc;
      }, {});

      const scheduleMap = schedules.reduce((acc, schedule) => {
        if (!acc[schedule.moduleID]) {
          acc[schedule.moduleID] = [];
        }
        acc[schedule.moduleID].push(schedule);
        return acc;
      }, {});

      const scheduleStudentWeeks = [];

      for (const module of modules) {
        const { moduleID, subjectID, lecturerID } = module;

        const moduleSchedules = scheduleMap[moduleID] || [];
        const subjectName = subjectMap[subjectID] || 'Unknown Subject';
        const lecturerName = lecturerMap[lecturerID] || 'Unknown Lecturer';

        for (const scheduleModel of moduleSchedules) {
          const { details, classRoomID } = scheduleModel;
          const roomName = roomMap[classRoomID] || 'Unknown Room';

          for (const week of details) {
            const { weekDetails, weekTimeStart, weekTimeEnd } = week;

            for (const weekDetail of weekDetails) {
              const { day, time, dayID } = weekDetail;
              const attendanceImages = attendanceMap[dayID] || [];
              const NoImages = attendanceImages.length;

              const scheduleStudentWeek = new ScheduleStudentWeekModel(
                day, time, moduleID, subjectName, roomName, lecturerName,
                week.week, weekTimeStart, weekTimeEnd, dayID, attendanceImages, NoImages
              );

              scheduleStudentWeeks.push(scheduleStudentWeek);
            }
          }
        }
      }
      return scheduleStudentWeeks;
    } catch (err) {
      console.error('Error retrieving schedule:', err.message);
      return [];
    } finally {
      console.timeEnd('ExecutionTime');
    }
  }
}

module.exports = ScheduleStudentWeekService;