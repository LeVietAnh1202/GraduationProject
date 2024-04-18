const router = require("express").Router();
const StudentController = require('../controller/subject.controller');

router.post("/createSubject", SubjectController.createSubject);

router.get("/getAllSubject", SubjectController.getAllSubject);



module.exports = router;