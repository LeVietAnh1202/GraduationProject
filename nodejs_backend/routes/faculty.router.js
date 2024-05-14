const router = require("express").Router();
const FacultyController = require('../controller/faculty.controller');

router.get("/getAllFaculty", FacultyController.getAllFaculty);



module.exports = router;