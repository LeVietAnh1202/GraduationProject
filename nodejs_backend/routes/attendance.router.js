const router = require("express").Router();
const AttendanceController = require('../controller/student.controller');

router.post("/createAttendance", AttendanceController.createAttendance);

router.get("/getAllAttendance", AttendanceController.getAllAttendance);



module.exports = router;