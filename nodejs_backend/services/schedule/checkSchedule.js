const ScheduleModel = require("../models/schedule/schedule.model");
// Hàm kiểm tra lịch học
class CheckScheduleService {
    static checkSchedule = async () => {
        const now = new Date(2024, 4, 24, 10, 30, 0);
        console.log(now);
        const schedules = await ScheduleModel.find({
            dateStart: { $lte: now },
            dateEnd: { $gte: now }
        });
        return schedules;

    };
}

module.exports = CheckScheduleService;