const router = require("express").Router();
const ScheduleAdminController = require('../controller/schedule/schedule_admin_term.controller');

router.post("/getAllScheduleAdminTerm", ScheduleAdminController.getAllScheduleAdminTerm);


module.exports = router;