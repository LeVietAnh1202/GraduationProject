const AttendanceStudentTermService = require('../../services/attendance/attendance_student_term.service');

exports.getAllAttendanceStudentTerm = async (req, res, next) => {
    try {
        const { studentId, moduleID } = req.body;

        const attendanceList = await AttendanceStudentTermService.getAllAttendanceStudentTerm(studentId, moduleID);
        res.json({ status: true, success: 'Get all attendanceList successfully', data: attendanceList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};