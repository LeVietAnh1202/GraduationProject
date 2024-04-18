const router = require("express").Router();
const RoomController = require('../controller/room.controller');

router.post("/createRoom", RoomController.createRoom);

router.get("/getAllRoom", RoomController.getAllRoom);



module.exports = router;