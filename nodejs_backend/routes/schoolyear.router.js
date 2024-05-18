const router = require("express").Router();
const SchoolyearController = require('../controller/schoolyear.controller');

// router.post("/createClass", ClassController.createClass);

router.get("/getAll", SchoolyearController.getAll);

module.exports = router;