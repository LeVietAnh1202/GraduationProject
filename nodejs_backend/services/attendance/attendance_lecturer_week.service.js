// const ScheduleModel = require("../../models/schedule/schedule.model");
// const ModuleModel = require("../../models/module.model");
// const AttendanceModel = require("../../models/attendance.model");
// const StudentModel = require("../../models/student.model");
// const AttendanceLecturerWeekModel = require("../../models/attendance/attendance_lecturer_week.model");
// const path = require('path');
// const fs = require('fs');

// class AttendanceLecturerWeekService {
//   static async getAllAttendanceLecturerWeek(lecturerID, dayID) {
//     try {
//       const studentAttendances = [];
//       var NoImagesValid = 0;
//       const attendances = await AttendanceModel.find({ dayID }).exec();

//       // Tìm Schedule có chứa dayID trong weekDetails
//       const schedule = await ScheduleModel.findOne({ 'details.weekDetails.dayID': dayID });
//       if (!schedule) {
//         throw new Error('Schedule with specified dayID not found');
//       }

//       const moduleID = schedule.moduleID;

//       // Tìm Module có moduleID tương ứng
//       const module = await ModuleModel.findOne({ moduleID });
//       const { listStudentID } = module;

//       for (const studentId of listStudentID) {
//         const student = await StudentModel.findOne({ studentId }).exec();
//         if (!student) {
//           console.log(`Student with ID ${studentId} not found`);
//           continue;
//         }

//         const studentName = student.studentName;
//         const classCode = student.classCode;
//         const gender = student.gender;

//         // Lấy thông tin điểm danh của sinh viên
//         const attendanceItem = await AttendanceModel.findOne({ dayID, studentId }).exec();
//         const attendance = attendanceItem ? attendanceItem.attendance : [];
//         const NoImages = attendance.length;
//         NoImagesValid += NoImages;

//         studentAttendances.push({
//           'studentId': studentId,
//           'studentName': studentName,
//           'classCode': classCode,
//           'gender': gender,
//           'attendance': attendance,
//           'NoImage': NoImages,
//         });
//       }

//       const attendanceLecturerTerm = new AttendanceLecturerWeekModel(studentAttendances);

//       return attendanceLecturerTerm;
//     } catch (err) {
//       console.log(err);
//     }
//   }
// }
// module.exports = AttendanceLecturerWeekService;

/* const ScheduleModel = require("../../models/schedule/schedule.model");
const ModuleModel = require("../../models/module.model");
const AttendanceModel = require("../../models/attendance.model");
const StudentModel = require("../../models/student.model");
const AttendanceLecturerWeekModel = require("../../models/attendance/attendance_lecturer_week.model");

class AttendanceLecturerWeekService {
  static async getAllAttendanceLecturerWeek(lecturerID, dayID) {
    try {
      const studentAttendances = [];
      let NoImagesValid = 0;

      // Tìm Schedule có chứa dayID trong weekDetails
      const schedule = await ScheduleModel.findOne({ 'details.weekDetails.dayID': dayID });
      if (!schedule) {
        throw new Error('Schedule with specified dayID not found');
      }

      const moduleID = schedule.moduleID;

      // Tìm Module có moduleID tương ứng
      const module = await ModuleModel.findOne({ moduleID });
      if (!module) {
        throw new Error('Module with specified moduleID not found');
      }

      const { listStudentID } = module;

      // Tìm tất cả sinh viên và thông tin điểm danh song song
      const students = await StudentModel.find({ studentId: { $in: listStudentID } }).exec();
      const attendances = await AttendanceModel.find({ dayID, studentId: { $in: listStudentID } }).exec();

      // Tạo một map để truy cập attendance theo studentId
      const attendanceMap = new Map();
      attendances.forEach(attendance => {
        attendanceMap.set(attendance.studentId, attendance.attendance || []);
      });

      for (const student of students) {
        const studentId = student.studentId;
        const studentName = student.studentName;
        const classCode = student.classCode;
        const gender = student.gender;
        const attendance = attendanceMap.get(studentId) || [];
        const NoImages = attendance.length;
        NoImagesValid += NoImages;

        studentAttendances.push({
          'studentId': studentId,
          'studentName': studentName,
          'classCode': classCode,
          'gender': gender,
          'attendance': attendance,
          'NoImage': NoImages,
        });
      }

      return new AttendanceLecturerWeekModel(studentAttendances);
    } catch (err) {
      console.error(err);
      throw err;
    }
  }
}

module.exports = AttendanceLecturerWeekService;
 */

const ScheduleModel = require("../../models/schedule/schedule.model");
const ModuleModel = require("../../models/module.model");
const AttendanceModel = require("../../models/attendance.model");
const StudentModel = require("../../models/student.model");
const AttendanceLecturerWeekModel = require("../../models/attendance/attendance_lecturer_week.model");

class AttendanceLecturerWeekService {
  static async getAllAttendanceLecturerWeek(lecturerID, dayID) {
    try {
      // Tìm Schedule có chứa dayID trong weekDetails
      const schedule = await ScheduleModel.findOne({ 'details.weekDetails.dayID': dayID }).exec();
      if (!schedule) {
        throw new Error('Schedule with specified dayID not found');
      }

      const moduleID = schedule.moduleID;

      // Tìm Module có moduleID tương ứng
      const module = await ModuleModel.findOne({ moduleID }).exec();
      if (!module) {
        throw new Error('Module with specified moduleID not found');
      }

      const { listStudentID } = module;

      // Tìm tất cả sinh viên và thông tin điểm danh
      const [students, attendances] = await Promise.all([
        StudentModel.find({ studentId: { $in: listStudentID } }).exec(),
        AttendanceModel.find({ dayID, studentId: { $in: listStudentID } }).exec(),
      ]);

      // Tạo một map để truy cập attendance theo studentId
      const attendanceMap = new Map();
      attendances.forEach(attendance => {
        attendanceMap.set(attendance.studentId, attendance.attendance || []);
      });

      // Tìm thông tin weekDetails cho dayID
      const weekDetail = schedule.details.flatMap(week => week.weekDetails).find(detail => detail.dayID === dayID);
      if (!weekDetail) {
        throw new Error('WeekDetails with specified dayID not found');
      }
      const { time } = weekDetail;
      const studentAttendances = students.map(student => {
        const studentId = student.studentId;
        const studentName = student.studentName;
        const classCode = student.classCode;
        const gender = student.gender;
        const attendance = attendanceMap.get(studentId) || [];
        const NoImages = attendance.length;

        return {
          studentId,
          studentName,
          classCode,
          gender,
          attendance,
          NoImage: NoImages,
        };
      });

      // Tính tổng số lượng hình ảnh hợp lệ
      // const NoImagesValid = studentAttendances.reduce((sum, student) => sum + student.NoImage, 0);

      // Tạo một đối tượng AttendanceLecturerWeekModel
      const attendanceLecturerTerm = new AttendanceLecturerWeekModel(
        studentAttendances,
        time,
      );

      return attendanceLecturerTerm;
    } catch (err) {
      console.error(err);
      throw err;
    }
  }
}

module.exports = AttendanceLecturerWeekService;
