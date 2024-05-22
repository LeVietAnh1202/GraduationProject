const router = require("express").Router();
const ScheduleController = require('../controller/schedule/schedule_admin_term.controller');

router.post("/getAllScheduleTerm", ScheduleController.getAllScheduleTerm);

module.exports = router;