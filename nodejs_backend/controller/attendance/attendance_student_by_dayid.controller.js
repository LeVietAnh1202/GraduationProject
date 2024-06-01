const AttendanceStudentByDayIDService = require('../../services/attendance/attendance_student_by_dayid.service');

exports.getAttendanceStudentByDayID = async (req, res, next) => {
    try {
        const {studentId, dayID} = req.body;
        const attendance = await AttendanceStudentByDayIDService.getAttendanceStudentByDayID(studentId, dayID);
        res.json({ status: true, success: 'Get getAttendanceStudentByDayID successfully', data: attendance });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};