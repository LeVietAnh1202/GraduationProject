const ScheduleLecturerTermService = require('../../services/schedule/schedule_lecturer_term.service');

exports.getAllScheduleLecturerTerm = async (req, res, next) => {
    try {
        const { lecturerID } = req.body;

        const scheduleList = await ScheduleLecturerTermService.getAllScheduleLecturerTerm(lecturerID);
        res.json({ status: true, success: 'Get all Schedules successfully', data: scheduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};