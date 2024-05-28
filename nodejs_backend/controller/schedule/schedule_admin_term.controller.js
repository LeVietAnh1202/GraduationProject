const ScheduleTermService = require('../../services/schedule/schedule_admin_term.service');

exports.getAllScheduleTerm = async (req, res, next) => {

    try {
        const { lecturerID, semesterID } = req.body;
        const scheduleList = await ScheduleTermService.getAllScheduleTerm(lecturerID, semesterID);
        res.json({ status: true, success: 'Get all Schedules successfully', data: scheduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

