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
    static periodTimes = {
        1: { start: "07:15", end: "08:05" },
        2: { start: "08:10", end: "09:00" },
        3: { start: "09:05", end: "09:55" },
        4: { start: "10:00", end: "10:50" },
        5: { start: "10:55", end: "11:45" },
        7: { start: "12:45", end: "13:35" },
        8: { start: "13:40", end: "14:30" },
        9: { start: "14:35", end: "15:25" },
        10: { start: "15:30", end: "16:20" },
        11: { start: "16:25", end: "17:15" }
    };

    static getClassTimes(weekTimeStart, day, time) {
        const [startPeriod, endPeriod] = time.split('-').map(Number);

        // Get the start date of the week
        const startDate = new Date(weekTimeStart);
        const dayOfWeek = parseInt(day);

        // Calculate the class date
        const classDate = new Date(startDate);
        classDate.setDate(startDate.getDate() + (dayOfWeek - 2)); // Adjust to match the provided daysOfWeek mapping

        // Calculate start and end times
        const startTime = ScheduleService.periodTimes[startPeriod].start.split(':');
        const endTime = ScheduleService.periodTimes[endPeriod].end.split(':');

        const classStartTime = new Date(classDate);
        classStartTime.setHours(parseInt(startTime[0]), parseInt(startTime[1]));

        const classEndTime = new Date(classDate);
        classEndTime.setHours(parseInt(endTime[0]), parseInt(endTime[1]));

        return { classStartTime, classEndTime };
    }

    static filterClassSchedules(classSchedules, now) {
        return classSchedules.filter(schedule => {
            return schedule.classStartTime <= now && schedule.classEndTime >= now;
        });
    }

    static async checkSchedule() {
        try {
            const now = new Date(2023, 10, 27, 7, 15, 0); // Lấy thời gian hiện tại

            // Tìm kiếm các lịch học với điều kiện dateStart nhỏ hơn thời gian hiện tại và dateEnd lớn hơn thời gian hiện tại
            const schedules = await ScheduleModel.find(
                {
                    dateStart: { $lt: now },
                    dateEnd: { $gt: now },
                    'details.weekTimeStart': { $lt: now },
                    'details.weekTimeEnd': { $gt: now }

                },
                'moduleID details', // Chỉ lấy ra trường details
            );

            // Extract only the relevant details entries
            const relevantDetails = schedules.flatMap(schedule =>
                schedule.details.filter(detail =>
                    detail.weekTimeStart < now && detail.weekTimeEnd > now
                ).map(detail => ({
                    moduleID: schedule.moduleID,
                    detail
                }))
            );

            // Calculate the class times for each relevant detail
            const classTimes = relevantDetails.map(({ moduleID, detail }) => {
                return detail.weekDetails.map(weekDetail => {
                    const { day, time, dayID } = weekDetail;
                    const { classStartTime, classEndTime } = ScheduleService.getClassTimes(detail.weekTimeStart, day, time);
                    return { moduleID, classStartTime, classEndTime, dayID };
                });
            }).flat();
            const filteredSchedules = ScheduleService.filterClassSchedules(classTimes, now);

            return filteredSchedules;
        } catch (error) {
            console.error("Lỗi khi lấy danh sách lịch học:", error);
            throw error; // Ném ra lỗi để xử lý ở nơi gọi hàm nếu cần
        }
    };

}



module.exports = ScheduleService;