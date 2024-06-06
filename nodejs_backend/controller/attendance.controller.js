const AttendanceService = require('../services/attendance.service');

exports.createOrUpdateAttendance = async (req, res, next) => {
    try {
        const { studentId, dayID, attendanceImagePath } = req.body;
        const studentName = await AttendanceService.createOrUpdateAttendance(studentId, dayID, attendanceImagePath);
        res.json({ status: true, success: `Sinh viên ${studentId} - ${studentName} điểm danh thành công.` });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

exports.updateNoImage = async (req, res, next) => {
    try {
        const { studentId, NoFullImage, NoCropImage } = req.body;
        const studentName = await AttendanceService.updateNoImage(studentId, NoFullImage, NoCropImage );
        res.json({ status: true, success: `Sinh viên ${studentId} - ${studentName} xử lý ảnh thành công.` });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

exports.uploadAttendanceImage = async (req, res, next) => {
    try {
        const studentName = await AttendanceService.uploadAttendanceImage(req);
        res.json({ status: true, success: `Sinh viên ${studentId} - ${studentName} thêm ảnh điểm danh thành công.` });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

exports.getAllAttendance = async (req, res, next) => {
    try {
        const attendanceList = await AttendanceService.getAllAttendance();
        res.json({ status: true, success: 'Get all attendance records successfully', data: attendanceList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};