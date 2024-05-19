const router = require("express").Router();
const LecturerController = require('../controller/lecturer.controller');
const ScheduleLecturerWeekController = require('../controller/schedule/schedule_lecturer_week.controller');
const ScheduleLecturerTermController = require('../controller/schedule/schedule_lecturer_term.controller');
const AttendanceLecturerTermController = require('../controller/attendance/attendance_lecturer_term.controller');
const AttendanceLecturerWeekController = require('../controller/attendance/attendance_lecturer_week.controller');



router.post("/createLecturer", LecturerController.createLecturer);

router.get("/getAllLecturer", LecturerController.getAllLecturer);

router.post("/getLecturersByFacultyID", LecturerController.getLecturersByFacultyID);

router.post("/getAllScheduleWeek", ScheduleLecturerWeekController.getAllScheduleLecturerWeek);

router.post("/getAllScheduleTerm", ScheduleLecturerTermController.getAllScheduleLecturerTerm);

router.post("/getAllAttendanceTerm", AttendanceLecturerTermController.getAllAttendanceLecturerTerm);

router.post("/getAllAttendanceWeek", AttendanceLecturerWeekController.getAllAttendanceLecturerWeek);





module.exports = router;