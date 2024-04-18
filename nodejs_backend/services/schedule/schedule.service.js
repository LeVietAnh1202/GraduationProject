const ScheduleModel = require("../../models/schedule/schedule.model");

class ScheduleService {
    static async createSchedule(scheduleID,dayTerm, moduleID, dateStart, dateEnd, details) {
        try {
            const createSchedule = new ScheduleModel({ scheduleID, moduleID,dayTerm, dateStart, dateEnd, details });
            return await createSchedule.save();
        } catch (err) {
            throw err;
        }
    }

    static async getScheduleByScheduleID(scheduleID) {
        try {
            return await ScheduleModel.findOne({ scheduleID });
        } catch (err) {
            console.log(err);
        }
    }

    static async getAllSchedule() {
        try {
            return await ScheduleModel.find();
        } catch (err) {
            console.log(err);
        }
    }
}

module.exports = ScheduleService;