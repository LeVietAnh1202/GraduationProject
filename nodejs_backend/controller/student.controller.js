const StudentService = require('../services/student.service');

exports.createStudent = async (req, res, next) => {
    try {
        const { studentId, studentName, classCode, gender, birthDate, avatar } = req.body;
        const duplicate = await StudentService.getStudentByStudentID(studentId);
        if (duplicate) {
            // throw new Error(`Student ${studentId}, Already Registered`);
            res.json({ status: true, success: 'StudentID Already' });
        }
        const response = await StudentService.createStudent(studentId, studentName, classCode, gender, birthDate, avatar);

        res.json({ status: true, success: 'Create Student successfully' });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}
exports.uploadAvatar = async (req, res, next) => {
    try {
        // Truyền tên và mã sinh viên cho middleware uploadAvatar()
        const uploadAvatarMiddleware = StudentService.uploadAvatar(req);
        res.json({ status: true, success: 'UploadImage Student successfully', data: uploadAvatarMiddleware });

    } catch (err) {
        console.log("---> err -->", err);
        next(err);
        // return res.status(500).json({ error: err.message });
    }
}
exports.getAllStudent = async (req, res, next) => {
    try {
        const studentList = await StudentService.getAllStudent();

        res.json({ status: true, success: 'GetAll Student successfully', data: studentList });

    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}
