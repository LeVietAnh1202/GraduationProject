const ScheduleService = require('../../services/schedule/schedule.service');

exports.createSchedule = async (req, res, next) => {
    try {
        const { scheduleId, moduleID, dateStart, dateEnd, details } = req.body;
        const duplicate = await ScheduleService.getScheduleByScheduleID(scheduleID);
        if (duplicate) {
            return res.json({ status: true, success: 'ScheduleID already exists' });
        }
        await ScheduleService.createSchedule(scheduleId, moduleID, dateStart, dateEnd, details);
        res.json({ status: true, success: 'Create Schedule successfully' });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

exports.getAllSchedule = async (req, res, next) => {
    try {
        const scheduleList = await ScheduleService.getAllSchedule();
        res.json({ status: true, success: 'Get all Schedules successfully', data: scheduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

exports.getCheckSchedule = async (req, res, next) => {
    try {
        const {simulationDate} = req.body;
        const scheduleList = await ScheduleService.checkSchedule(simulationDate);
        res.json({ status: true, success: 'CheckSchedule successfully', data: scheduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};