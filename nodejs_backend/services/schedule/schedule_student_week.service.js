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
      /* const student = await StudentModel.findOne({ studentId: studentId });
      const classCode = student.classCode;

      const modules = await ModuleModel.find({ classCode });

      const scheduleStudentWeeks = [];

      for (const module of modules) {
        const { moduleID, lecturerID } = module;
        const scheduleModels = await ScheduleModel.find({ moduleID });
        const lecturer = await LecturerModel.findOne({ lecturerID });

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

      return scheduleStudentWeeks; */

      const student = await StudentModel.findOne({ studentId });
      if (!student) throw new Error('Student not found');
      
      const { classCode } = student;
    
      const modules = await ModuleModel.find({ classCode });
      if (modules.length === 0) throw new Error('No modules found for the class code');
    
      const scheduleStudentWeeks = [];
    
      // Fetch schedules and lecturers in parallel
      const moduleIDs = modules.map(module => module.moduleID);
      const lecturerIDs = modules.map(module => module.lecturerID);
    
      const [schedules, lecturers] = await Promise.all([
        ScheduleModel.find({ moduleID: { $in: moduleIDs } }),
        LecturerModel.find({ lecturerID: { $in: lecturerIDs } })
      ]);
    
      // Create a map for quick lookup
      const lecturerMap = lecturers.reduce((acc, lecturer) => {
        acc[lecturer.lecturerID] = lecturer;
        return acc;
      }, {});
    
      const scheduleMap = schedules.reduce((acc, schedule) => {
        if (!acc[schedule.moduleID]) {
          acc[schedule.moduleID] = [];
        }
        acc[schedule.moduleID].push(schedule);
        return acc;
      }, {});
    
      for (const module of modules) {
        const { moduleID, subjectID, lecturerID } = module;
    
        const moduleSchedules = scheduleMap[moduleID] || [];
        const lecturer = lecturerMap[lecturerID];
    
        const subject = await SubjectModel.findOne({ subjectID });
        if (!subject) throw new Error('Subject not found');
    
        const subjectName = subject.subjectName;
        const lecturerName = lecturer ? lecturer.lecturerName : 'Unknown Lecturer';
    
        for (const scheduleModel of moduleSchedules) {
          const { details, classRoomID } = scheduleModel;
          const room = await RoomModel.findOne({ classRoomID });
          const roomName = room ? room.roomName : 'Unknown Room';
    
          for (const week of details) {
            const { weekDetails, weekTimeStart, weekTimeEnd } = week;
    
            for (const weekDetail of weekDetails) {
              const { day, time, dayID } = weekDetail;
              const attendance = await AttendanceModel.findOne({ studentId, dayID });
    
              const scheduleStudentWeek = new ScheduleStudentWeekModel(
                day, time, moduleID, subjectName, roomName, lecturerName,
                week.week, weekTimeStart, weekTimeEnd, dayID, attendance?.attendance
              );
    
              scheduleStudentWeeks.push(scheduleStudentWeek);
            }
          }
        }
      }
      // console.timeEnd('Execution Time');
      return scheduleStudentWeeks;
    } catch (err) {
      console.error(err);
      console.timeEnd('ExecutionTime');
      return []; // or handle the error as needed
    } finally {
      console.timeEnd('ExecutionTime');
    }
  }
}
module.exports = ScheduleStudentWeekService;