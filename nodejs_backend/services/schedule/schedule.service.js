const ScheduleModel = require("../../models/schedule/schedule.model");

class ScheduleService {
    static async createSchedule(scheduleID, dayTerm, moduleID, dateStart, dateEnd, details) {
        try {
            const createSchedule = new ScheduleModel({ scheduleID, moduleID, dayTerm, dateStart, dateEnd, details });
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

    static checkSchedule = async () => {
        try {
            const now = new Date(2023, 9, 17, 7, 0, 0); // Lấy thời gian hiện tại

            // Tìm kiếm các lịch học với điều kiện dateStart nhỏ hơn thời gian hiện tại và dateEnd lớn hơn thời gian hiện tại
            const schedules = await ScheduleModel.find({
                dateStart: { $lt: now },
                dateEnd: { $gt: now }
            });
            console.log(schedules)
            return schedules;
        } catch (error) {
            console.error("Lỗi khi lấy danh sách lịch học:", error);
            throw error; // Ném ra lỗi để xử lý ở nơi gọi hàm nếu cần
        }
    };
}

module.exports = ScheduleService;