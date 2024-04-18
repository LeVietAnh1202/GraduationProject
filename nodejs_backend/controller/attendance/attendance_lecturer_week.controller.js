const AttendanceLecturerWeekService = require('../../services/attendance/attendance_lecturer_week.service');

exports.getAllAttendanceLecturerWeek = async (req, res, next) => {
    try {
        const { lecturerId, dayID } = req.body;
        console.log('dayID' + dayID);

        const attendanceList = await AttendanceLecturerWeekService.getAllAttendanceLecturerWeek(lecturerId, dayID);
        res.json({ status: true, success: 'Get all attendanceList successfully', data: attendanceList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};