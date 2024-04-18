const router = require("express").Router();
const DeviceController = require('../controller/device.controller');

router.post("/createDevice", DeviceController.createDevice);

router.get("/getAllDevice", DeviceController.getAllDevice);



module.exports = router;