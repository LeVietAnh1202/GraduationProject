const AttendanceService = require('../services/attendance.service');

exports.createAttendance = async (req, res, next) => {
    try {
        const { studentId, scheduleID, attendance } = req.body;
        const duplicate = await AttendanceService.getAttendanceByStudentId(studentId);
        if (duplicate) {
            return res.json({ status: true, success: 'Attendance record already exists' });
        }
        await AttendanceService.createAttendance(studentId, scheduleID, attendance);
        res.json({ status: true, success: 'Create attendance record successfully' });
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