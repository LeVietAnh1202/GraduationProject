const StudentService = require('../services/student.service');

exports.createStudent = async (req, res, next) => {
    try {
        const { studentId, studentName, classCode, specializationID, gender, birthDate, avatar, video } = req.body;
        const duplicate = await StudentService.getStudentByStudentID(studentId);
        if (duplicate) {
            // throw new Error(`Student ${studentId}, Already Registered`);
            res.json({ status: true, success: 'StudentID Already' });
        }
        const response = await StudentService.createStudent(studentId, studentName, classCode, specializationID, gender, birthDate, avatar, video);

        res.json({ status: true, success: 'Create Student successfully' });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}
exports.editStudent = async (req, res, next) => {
    try {
        const { studentId, studentName, classCode, specializationID, gender,  birthDate } = req.body;
        const duplicate = await StudentService.getStudentByStudentID(studentId);

        if (!duplicate) {
            // throw new Error(`Student ${studentId}, Already Registered`);
            res.status(404).json({ status: false, error: 'Student not found' });
        }
        const response = await StudentService.editStudent(studentId, studentName, classCode, specializationID,  gender, birthDate);

        res.json({ status: true, success: 'Edit Student successfully' });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.deleteStudent = async (req, res, next) => {
    try {
        const { studentId } = req.params;

        const exist = await StudentService.getStudentByStudentID(studentId);

        if (!exist) {
            return res.status(404).json({ status: false, error: 'Student not found' });
        }

        const deletedStudent = await StudentService.deleteStudent(studentId);

        res.json({ status: true, data: deletedStudent, success: 'Delete Student successfully' });

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

exports.uploadVideo = async (req, res, next) => {
    if (!req) {
        return res.status(400).json({ error: 'Request object is null' });
    }

    try {
        // Gọi phương thức uploadVideo từ Service để xử lý tải lên video
        const uploadVideoMiddleware = await StudentService.uploadVideo(req);
        res.json({ status: true, success: 'Upload video successfully', data: uploadVideoMiddleware });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
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

exports.getStudentByModuleID = async (req, res, next) => {
    try {
        const { moduleID } = req.body;
        const studentList = await StudentService.getStudentByModuleID(moduleID);

        res.json({ status: true, success: 'getStudentByModuleID successfully', data: studentList });

    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.getStudentsByFacultyID = async (req, res, next) => {
    try {
        const { lecturerID } = req.body;
        const studentList = await StudentService.getStudentsByFacultyID(lecturerID);

        res.json({ status: true, success: 'get students by facultyID successfully', data: studentList });

    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}
