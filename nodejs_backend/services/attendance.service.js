const AttendanceModel = require('../models/attendance.model');
const StudentModel = require('../models/student.model');

class AttendanceService {
  static async createOrUpdateAttendance(studentId, dayID, attendanceImagePath) {
    try {
      // Sử dụng findOneAndUpdate để tìm và cập nhật bản ghi trong một lệnh duy nhất
      const attendanceRecord = await AttendanceModel.findOneAndUpdate(
        { studentId, dayID },
        { $addToSet: { attendance: attendanceImagePath } }, // Thêm ảnh vào mảng attendance nếu nó chưa tồn tại
        { new: true, upsert: true } // Tạo mới nếu không tồn tại, trả về bản ghi sau khi cập nhật
      );

      // Lấy tên sinh viên chỉ khi cần thiết
      const student = await StudentModel.findOne({ studentId });
      if (!student) console.log('Student not found');

      return student.studentName;

    } catch (err) {
      console.log(err);
      throw err; // Ném lại lỗi để xử lý ở nơi gọi hàm này
    }
  }

  static uploadAttendanceImage(req) {
    return new Promise((resolve, reject) => {
      const storage = multer.diskStorage({
        destination: function (req, file, cb) {
          cb(null, './public/images/attendance_images'); // Thư mục lưu trữ avatar
        },
        filename: function (req, file, cb) {
          const fileName = file.originalname;
          cb(null, fileName); // Sử dụng tên file được gửi
        }
      });

      const upload = multer({ storage: storage }).single('image');

      upload(req, {}, (err) => {
        if (err) {
          reject(err);
        } else {
          resolve(req.file.filename); // Trả về tên file đã được đặt
        }
      });
    });
  }

  static async getAttendanceByStudentId(studentId) {
    try {
      return await AttendanceModel.findOne({ studentId });
    } catch (err) {
      console.log(err);
    }
  }

  static async getAllAttendance() {
    try {
      return await AttendanceModel.find();
    } catch (err) {
      console.log(err);
    }
  }
}

module.exports = AttendanceService;