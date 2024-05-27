const router = require("express").Router();
const FacultyController = require('../controller/faculty.controller');

router.get("/getAllFaculty", FacultyController.getAllFaculty);

router.post("/getFacultyByLecturerID", FacultyController.getFacultyByLecturerID);

router.post("/getFacultyByStudentID", FacultyController.getFacultyByStudentID);

router.post("/getSpecializationsByLecturerID", FacultyController.getSpecializationsByLecturerID);



module.exports = router;