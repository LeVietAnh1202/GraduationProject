const AttendanceLecturerWeekService = require('../../services/attendance/attendance_lecturer_week.service');

exports.getAllAttendanceLecturerWeek = async (req, res, next) => {
    try {
        const { lecturerID, dayID, date, time } = req.body;

        const attendanceList = await AttendanceLecturerWeekService.getAllAttendanceLecturerWeek(lecturerID, dayID, date, time);
        res.json({ status: true, success: 'Get all attendanceList successfully', data: attendanceList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};