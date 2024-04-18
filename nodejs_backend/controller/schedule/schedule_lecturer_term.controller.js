const ScheduleLecturerTermService = require('../../services/schedule/schedule_lecturer_term.service');

exports.getAllScheduleLecturerTerm = async (req, res, next) => {
    try {
        const { lecturerId } = req.body;

        const scheduleList = await ScheduleLecturerTermService.getAllScheduleLecturerTerm(lecturerId);
        res.json({ status: true, success: 'Get all Schedules successfully', data: scheduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};