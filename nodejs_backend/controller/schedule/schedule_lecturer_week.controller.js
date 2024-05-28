const ScheduleLecturerWeekService = require('../../services/schedule/schedule_lecturer_week.service');

exports.getAllScheduleLecturerWeek = async (req, res, next) => {
    try {
        const { lecturerID } = req.body;

        const scheduleList = await ScheduleLecturerWeekService.getAllScheduleLecturerWeek(lecturerID);
        res.json({ status: true, success: 'Get all Schedules successfully', data: scheduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};