const AttendanceLecturerTermService = require('../../services/attendance/attendance_lecturer_term.service');

exports.getAllAttendanceLecturerTerm = async (req, res, next) => {
    try {
        const { lecturerID, moduleID } = req.body;

        const attendanceList = await AttendanceLecturerTermService.getAllAttendanceLecturerTerm(lecturerID, moduleID);
        res.json({ status: true, success: 'Get all attendanceList successfully', data: attendanceList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};