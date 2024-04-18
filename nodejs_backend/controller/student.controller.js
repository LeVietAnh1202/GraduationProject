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
exports.getAllStudent = async (req, res, next) => {
    try {
        const studentList = await StudentService.getAllStudent();

        res.json({ status: true, success: 'GetAll Student successfully', data: studentList });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}
