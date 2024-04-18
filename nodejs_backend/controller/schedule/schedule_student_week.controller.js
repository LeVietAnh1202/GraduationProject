const ScheduleStudentWeekService = require('../../services/schedule/schedule_student_week.service');

exports.getAllScheduleStudentWeek = async (req, res, next) => {
    try {
        console.log(req.body)
        const { studentId } = req.body;

        const scheduleList = await ScheduleStudentWeekService.getAllScheduleStudentWeek(studentId);
        res.json({ status: true, success: 'Get all Schedules successfully', data: scheduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};