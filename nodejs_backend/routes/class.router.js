const router = require("express").Router();
const ClassController = require('../controller/class.controller');

router.post("/createClass", ClassController.createClass);

router.get("/getAllClass", ClassController.getAllClass);



module.exports = router;