const StudentModel = require("../models/student.model");

const multer = require('multer');
const fs = require('fs');
const path = require('path');
class StudentService {
    static async createStudent(studentId, studentName, classCode, gender, birthDate, avatar, video) {
        try {
            const createStudent = new StudentModel({ studentId, studentName, classCode, gender, birthDate, avatar, video });
            return await createStudent.save();
        } catch (err) {
            throw err;
        }
    }
    static async editStudent(studentId, studentName, classCode, gender, birthDate) {
        try {
            // Tìm sinh viên cần cập nhật bằng studentId và cập nhật thông tin mới
            return await StudentModel.findOneAndUpdate(
                { studentId: studentId }, // Điều kiện tìm kiếm
                { studentName: studentName, classCode: classCode, gender: gender, birthDate: birthDate }, // Thông tin cập nhật
                { new: true } // Tùy chọn: Trả về bản ghi đã được cập nhật
            );
        } catch (err) {
            throw err;
        }
    }

    static async deleteStudent(studentId) {
        try {
            // Tìm sinh viên cần xóa bằng studentId
            const student = await StudentModel.findOneAndDelete({ studentId });

            // Kiểm tra xem sinh viên có tồn tại không
            // if (!student) {
            //     throw new Error('Student not found');
            // }
            console.log(student)
            // const student = await StudentService.getStudentByStudentID(studentId);
            console.log(path.join(__dirname, `../public/images/default/avatar/${student.avatar}`));
            // Xóa hình ảnh và video liên quan đến sinh viên
            const imagePath = path.join(__dirname, `../public/images/default/avatar/${student.avatar}`);
            const videoPath = path.join(__dirname, `../public/videos/default/${student.video}`);

            // Xóa hình ảnh
            if (fs.existsSync(imagePath)) {
                fs.unlinkSync(imagePath);
            }

            // Xóa video
            if (fs.existsSync(videoPath)) {
                fs.unlinkSync(videoPath);
            }

            return student; // Trả về sinh viên đã bị xóa
        } catch (err) {
            throw err;
        }
    }

    static async getStudentByStudentID(studentId) {
        console.log('HTHI StudenID:', studentId);
        try {
            return await StudentModel.findOne({ studentId });
        } catch (err) {
            console.log(err);
        }
    }
    static async getAllStudent() {
        try {
            return await StudentModel.find();
        } catch (err) {
            console.log(err);
        }
    }

    static uploadAvatar(req) {
        // // Cấu hình Multer để tải lên avatar
        // const storage = multer.diskStorage({
        //     destination: function (req, file, cb) {
        //         cb(null, './public/images/default/avatar'); // Thư mục lưu trữ avatar
        //     },
        //     filename: function (req, file, cb) {
        //         // const fileName = `${studentId}_${studentName}${path.extname(file.originalname)}`;
        //         const fileName = file.originalname;
        //         print(fileName)
        //         cb(null, fileName); // Sử dụng tên và mã sinh viên để đặt tên cho file

        //     }
        // });

        // const upload = multer({ storage: storage }).single('image');

        // return upload;

        return new Promise((resolve, reject) => {
            const storage = multer.diskStorage({
                destination: function (req, file, cb) {
                    cb(null, './public/images/default/avatar'); // Thư mục lưu trữ avatar
                },
                filename: function (req, file, cb) {
                    const fileName = file.originalname;
                    // console.log(fileName);
                    cb(null, fileName); // Sử dụng tên file gốc
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

    static uploadVideo(req) {
        return new Promise((resolve, reject) => {
            const storage = multer.diskStorage({
                destination: function (req, file, cb) {
                    cb(null, './public/videos/default'); // Thư mục lưu trữ video
                },
                filename: function (req, file, cb) {
                    const fileName = file.originalname;
                    // console.log(fileName);
                    cb(null, fileName); // Sử dụng tên file gốc
                }
            });

            const upload = multer({ storage: storage }).single('video');

            upload(req, {}, (err) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(req.file.filename); // Trả về tên file đã được đặt
                }
            });
        });
    }



}

module.exports = StudentService;