const router = require("express").Router();
const SubjectController = require('../controller/subject.controller');

router.post("/getSubjectsByLecturerID", SubjectController.getSubjectsByLecturerID);

router.get("/getAll", SubjectController.getAllSubject);

module.exports = router;