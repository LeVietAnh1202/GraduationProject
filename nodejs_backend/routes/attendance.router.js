const router = require("express").Router();
const AttendanceController = require('../controller/attendance.controller');

router.post("/createOrUpdateAttendance", AttendanceController.createOrUpdateAttendance);

router.post("/updateNoImage", AttendanceController.updateNoImage);

router.post("/uploadAttendanceImage", AttendanceController.uploadAttendanceImage);

router.get("/getAllAttendance", AttendanceController.getAllAttendance);



module.exports = router;