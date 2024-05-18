const router = require("express").Router();
const SubjectController = require('../controller/subject.controller');


router.get("/getAll", SubjectController.getAllSubject);

module.exports = router;