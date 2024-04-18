const ImageService = require('..//../services/load_image/load_image.service');

// Controller để xử lý yêu cầu lấy ảnh dựa trên studentId
async function getImagesRootByStudentId(req, res, next) {
    try {
        // Lấy studentId từ request params
        const studentId = req.params.studentId;

        // Gọi service để lấy dữ liệu ảnh dựa trên studentId
        const imageData = await ImageService.getImagesRootByStudentId(studentId);

        // Trả về dữ liệu ảnh cho client
        res.send(imageData);
    } catch (error) {
        // Xử lý lỗi nếu có
        next(error);
    }
}

module.exports = {
    getImagesRootByStudentId
};
