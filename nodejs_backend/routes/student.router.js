const router = require("express").Router();
const StudentController = require('../controller/student.controller');
const ScheduleStudentWeekController = require('../controller/schedule/schedule_student_week.controller');
const ScheduleStudentTermController = require('../controller/schedule/schedule_student_term.controller');
const AttendanceStudentTermController = require('../controller/attendance/attendance_student_term.controller');
const AttendanceStudentByDayIDController = require('../controller/attendance/attendance_student_by_dayid.controller');

router.post("/create", StudentController.createStudent);

router.post("/edit", StudentController.editStudent);

router.delete("/delete/:studentId", StudentController.deleteStudent);

router.post("/uploadAvatar", StudentController.uploadAvatar);

router.post("/uploadVideo", StudentController.uploadVideo);

router.get("/getAll", StudentController.getAllStudent);

router.post("/getStudentsByFacultyID", StudentController.getStudentsByFacultyID);

router.post("/getStudentByModuleID", StudentController.getStudentByModuleID);

router.post("/getAllScheduleWeek", ScheduleStudentWeekController.getAllScheduleStudentWeek);

router.post("/getAllScheduleTerm", ScheduleStudentTermController.getAllScheduleStudentTerm);

router.post("/getAllAttendanceTerm", AttendanceStudentTermController.getAllAttendanceStudentTerm);

router.post("/getAttendanceStudentByDayID", AttendanceStudentByDayIDController.getAttendanceStudentByDayID);

module.exports = router;

