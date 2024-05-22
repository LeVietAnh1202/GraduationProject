const router = require("express").Router();
const FacultyController = require('../controller/faculty.controller');

router.get("/getAllFaculty", FacultyController.getAllFaculty);

router.post("/getSpecializationsByLecturerID", FacultyController.getSpecializationsByLecturerID);



module.exports = router;