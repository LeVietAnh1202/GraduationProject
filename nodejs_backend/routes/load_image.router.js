const express = require('express');
const router = express.Router();
const imageController = require('../controller/load_image/load_image.controller');

// Định nghĩa tuyến API để lấy ảnh dựa trên studentId
router.get('/images_root/:studentId', imageController.getImagesRootByStudentId);

module.exports = router;
