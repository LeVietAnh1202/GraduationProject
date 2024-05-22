const router = require("express").Router();
const ModuleController = require('../controller/module.controller');

router.post("/createModule", ModuleController.createModule);

router.get("/getAllModule", ModuleController.getAllModule);

router.post("/getAllModuleTermByLecturerID", ModuleController.getAllModuleTermByLecturerID);


module.exports = router;