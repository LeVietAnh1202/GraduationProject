const fs = require('fs');
const path = require('path');

var index = 0;
const directoryPath = 'G:/Ki_8/GraduationProject/nodejs_backend/public/videos/default';

const arr = [
    '10120603_DoQuynhAnh.mp4',
    '12520088_LeVietAnh.mp4',
    '10120766_NguyenMinhAnh.mp4',
    '10120620_NguyenMinhDoanh.mp4',
    '10120623_NguyenThaiDuong.mp4',
    '10120626_LeHaiDang.mp4',
    '10120635_PhamThanhHang.mp4',
    '10120741_LuuHuyHoang.mp4',
    '10120745_NguyenManhHung.mp4',
    '10120056_LeNgocLanh.mp4',
    '10120792_ThanThiMyLinh.mp4',
    '10120748_TrinhThiLinh.mp4',
    '10120669_DaoNgocLong.mp4',
    '10120674_NguyenThiCamLy.mp4',
    '10120678_VuNgocMinh.mp4',
    '10120683_DangNgocNhan.mp4',
    '10120773_NguyenThiNgocPhuong.mp4',
    '10120701_LeHoangSon.mp4',
    '10120707_NguyenVanThai.mp4',
    '10120734_TranAnhTu.mp4',
    '10120736_DoTrangTuan.mp4',
]

fs.readdir(directoryPath, function (err, files) {
    if (err) {
        return console.log('Unable to scan directory: ' + err);
    }

    files.forEach(function (file) {
        const oldPath = path.join(directoryPath, file);
        // const result = file.match(/_(.*?)\./);
        // const extractedString = result[1];
        const newName = arr[index++]; // Tên mới của tệp
        // console.log(newName);
        // console.log(file)
        const newPath = path.join(directoryPath, newName);

        fs.rename(oldPath, newPath, function (err) {
            if (err) {
                console.log('Error renaming file: ' + err);
            } else {
                console.log(`File ${file} renamed to ${newName}`);
            }
        });
    });
});
