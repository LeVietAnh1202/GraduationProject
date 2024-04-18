const router = require("express").Router();
const ScheduleController = require('../controller/schedule/schedule.controller');

router.post("/createSchedule", ScheduleController.createSchedule);

router.get("/getAllSchedule", ScheduleController.getAllSchedule);
// router.get("/getAllScheduleStudentTerm", ScheduleController.getAllSchedule);

/student/getAllScheduleWeek

module.exports = router;