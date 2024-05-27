const StudentModel = require("../models/student.model");
const ModuleModel = require("../models/module.model");
const FacultyModel = require("../models/faculty.model");
const LecturerModel = require("../models/lecturer.model");

const multer = require('multer');
const fs = require('fs');
const path = require('path');
const Lecturer = require("../models/lecturer.model");
class StudentService {
    static async createStudent(studentId, studentName, classCode, specializationID, gender, birthDate, avatar, video) {
        try {
            const createStudent = new StudentModel({ studentId, studentName, classCode, specializationID, gender, birthDate, avatar, video });
            return await createStudent.save();
        } catch (err) {
            throw err;
        }
    }
    static async editStudent(studentId, studentName, classCode, specializationID, gender, birthDate) {
        try {
            // Tìm sinh viên cần cập nhật bằng studentId và cập nhật thông tin mới
            return await StudentModel.findOneAndUpdate(
                { studentId: studentId }, // Điều kiện tìm kiếm
                { studentName: studentName, classCode: classCode, specializationID: specializationID, gender: gender, birthDate: birthDate }, // Thông tin cập nhật
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
            // Lấy tất cả sinh viên
            const students = await StudentModel.find();

            // Lấy tất cả dữ liệu từ FacultyModel
            const faculties = await FacultyModel.find();

            // Tạo một bản đồ (map) để nhanh chóng tra cứu specializationID -> specializationName
            const specializationMap = new Map();
            faculties.forEach(faculty => {
                faculty.majors.forEach(major => {
                    major.specializations.forEach(specialization => {
                        specializationMap.set(specialization.specializationID, specialization.specializationName);
                    });
                });
            });

            // Thêm specializationName cho mỗi sinh viên dựa trên specializationID
            const studentsWithSpecialization = students.map(student => {
                const specializationName = specializationMap.get(student.specializationID) || 'Unknown';
                return {
                    ...student.toObject(), // Chuyển đổi document MongoDB thành object JS
                    specializationName: specializationName
                };
            });

            return studentsWithSpecialization;
        } catch (err) {
            console.error(err);
            throw err; // Ném lỗi để xử lý ở cấp cao hơn nếu cần
        }
    }


    static async getStudentsByFacultyID(lecturerID) {
        try {
            const lecturer = await LecturerModel.findOne({ lecturerID });
            const faculty = await FacultyModel.findOne({ facultyID: lecturer.facultyID });

            const specializationIDs = [];
            for (const major of faculty.majors) {
                for (const specialization of major.specializations) {
                    specializationIDs.push(specialization.specializationID);
                }
            }

            const students = await StudentModel.find({ specializationID: { $in: specializationIDs } });

            const specializationMap = new Map();

            const faculties = await FacultyModel.find();
            faculties.forEach(faculty => {
                faculty.majors.forEach(major => {
                    major.specializations.forEach(specialization => {
                        specializationMap.set(specialization.specializationID, specialization.specializationName);
                    });
                });
            });

            const studentsWithSpecialization = students.map(student => {
                const specializationName = specializationMap.get(student.specializationID) || 'Unknown';
                return {
                    ...student.toObject(), // Chuyển đổi document MongoDB thành object JS
                    specializationName: specializationName
                };
            });


            return studentsWithSpecialization;
        } catch (err) {
            console.log(err);
            throw err;  // Ném lỗi ra để có thể xử lý ở nơi khác nếu cần
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

    static async getStudentByModuleID(moduleID) {
        try {
            // const { listStudentID } = await ModuleModel.findOne({ moduleID: moduleID });
            const module = await ModuleModel.findOne({ moduleID: moduleID });
            console.log(moduleID)

            if (!module) {
                throw new Error(`Module with ID ${moduleID} not found`);
            }

            // Extract the list of student IDs
            const listStudentID = module.listStudentID;
            console.log(listStudentID)
            const students = await StudentModel.find({ studentId: { $in: listStudentID } });

            const specializationMap = new Map();

            const faculties = await FacultyModel.find();
            faculties.forEach(faculty => {
                faculty.majors.forEach(major => {
                    major.specializations.forEach(specialization => {
                        specializationMap.set(specialization.specializationID, specialization.specializationName);
                    });
                });
            });

            const studentsWithSpecialization = students.map(student => {
                const specializationName = specializationMap.get(student.specializationID) || 'Unknown';
                return {
                    ...student.toObject(), // Chuyển đổi document MongoDB thành object JS
                    specializationName: specializationName
                };
            });

            return studentsWithSpecialization;

        } catch (err) {
            console.log(err);
        }
    }
}

module.exports = StudentService;