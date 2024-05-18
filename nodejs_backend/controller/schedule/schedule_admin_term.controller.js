const ScheduleAdminTermService = require('../../services/schedule/schedule_admin_term.service');

exports.getAllScheduleAdminTerm = async (req, res, next) => {
    try {
        const { lecturerID, subjectID, semesterID } = req.body;
        console.log(lecturerID, subjectID, semesterID);
        const scheduleList = await ScheduleAdminTermService.getAllScheduleAdminTerm(lecturerID, subjectID, semesterID);
        res.json({ status: true, success: 'Get all Schedules successfully', data: scheduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};