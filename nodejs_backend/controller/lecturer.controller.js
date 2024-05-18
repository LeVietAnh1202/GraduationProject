const LecturerService = require('../services/lecturer.service');

exports.createLecturer = async (req, res, next) => {
    try {

        const { lecturerID, lecturerName, gender, birthDate } = req.body;
        const duplicate = await StudentService.getStudentByStudentID(studentId);
        if (duplicate) {
            // throw new Error(`Student ${studentId}, Already Registered`);
            res.json({ status: true, success: 'LecturerID Already' });
        }
        const response = await LecturerService.createStudent(lecturerID, lecturerName, gender, birthDate);

        res.json({ status: true, success: 'Create Lecturer successfully' });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}
exports.getAllLecturer = async (req, res, next) => {
    try {
        const lecturerList = await LecturerService.getAllLecturer();

        res.json({ status: true, success: 'GetAll Lecturer successfully', data: lecturerList });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}
