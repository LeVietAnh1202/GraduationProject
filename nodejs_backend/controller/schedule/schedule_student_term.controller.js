const ScheduleStudentTermService = require('../../services/schedule/schedule_student_term.service');

exports.getAllScheduleStudentTerm = async (req, res, next) => {
    try {
        const { studentId } = req.body;

        const scheduleList = await ScheduleStudentTermService.getAllScheduleStudentTerm(studentId);
        res.json({ status: true, success: 'Get all Schedules successfully', data: scheduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};