const router = require("express").Router();
const StudentController = require('../controller/student.controller');
const ScheduleStudentWeekController = require('../controller/schedule/schedule_student_week.controller');
const ScheduleStudentTermController = require('../controller/schedule/schedule_student_term.controller');
const AttendanceStudentTermController = require('../controller/attendance/attendance_student_term.controller');


router.post("/create", StudentController.createStudent);

router.get("/getAll", StudentController.getAllStudent);

router.post("/getAllScheduleWeek", ScheduleStudentWeekController.getAllScheduleStudentWeek);

router.post("/getAllScheduleTerm", ScheduleStudentTermController.getAllScheduleStudentTerm);

router.post("/getAllAttendanceTerm", AttendanceStudentTermController.getAllAttendanceStudentTerm);




module.exports = router;