const ScheduleModel = require("../../models/schedule/schedule.model");
const ModuleModel = require("../../models/module.model");
const AttendanceModel = require("../../models/attendance.model");
const StudentModel = require("../../models/student.model");
const AttendanceLecturerWeekModel = require("../../models/attendance/attendance_lecturer_week.model");
const path = require('path');
const fs = require('fs');

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

        const { studentId, date, time } = attendanceItem;
        const student = await StudentModel.findOne({ studentId }).exec();;
        const studentName = student.studentName;

        const studentImagePath = path.join(__dirname, '..', '..', 'public', 'images', 'attendance_images', dayID, `${studentId}`);

        const studentImages = [];
        console.log(studentImagePath)
        // "G:\\Ki_8\\GraduationProject\\nodejs_backend\\public\\images\\attendance_images\\1008\\10120620"

        // Kiểm tra xem thư mục tồn tại hay không
        if (fs.existsSync(studentImagePath)) {
          console.log("studentImagePath already exists")

          // Lấy danh sách các tệp trong thư mục
          const files = fs.readdirSync(studentImagePath);
          // Lặp qua từng tệp và tạo đường dẫn đầy đủ cho mỗi tệp
          files.forEach(file => {
            const imagePath = path.join(dayID, `${studentId}`, file);
            studentImages.push(imagePath);
            console.log(studentImagePath)
          });
        }
        else { console.log('Student no exists') }

        studentAttendances.push({ [studentName]: attendanceValue, 'attendanceImages': studentImages });
      }

      const attendanceLecturerTerm = new AttendanceLecturerWeekModel(studentAttendances, numberOfOnTimeSessions, numberOfLateSessions, numberOfBreaksSessions);

      return attendanceLecturerTerm;
    } catch (err) {
      console.log(err);
    }
  }
}
module.exports = AttendanceLecturerWeekService;