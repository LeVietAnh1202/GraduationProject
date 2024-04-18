const fs = require('fs');
const path = require('path');

var index = 1;
const directoryPath = 'D:/DHCQ-2020-2024/2023-2024_Ky 2/DATN/Project/Project_Flutter_NodeJS/nodejs_backend/public/images/full_images/10120056_LeNgocLanh';

const arr = [
    '10120603_DoQuynhAnh.jpg',
    '12520088_LeVietAnh.jpg',
    '10120766_NguyenMinhAnh.jpg',
    '10120623_NguyenThaiDuong.jpg',
    '10120626_LeHaiDang.jpg',
    '10120635_PhamThanhHang.jpg',
    '10120741_LuuHuyHoang.jpg',
    '10120745_NguyenManhHung.jpg',
    '10120056_LeNgocLanh.jpg',
    '10120792_ThanThiMyLinh.jpg',
    '10120748_TrinhThiLinh.jpg',
    '10120669_DaoNgocLong.jpg',
    '10120674_NguyenThiCamLy.jpg',
    '10120678_VuNgocMinh.jpg',
    '10120683_DangNgocNhan.jpg',
    '10120773_NguyenThiNgocPhuong.jpg',
    '10120701_LeHoangSon.jpg',
    '10120707_NguyenVanThai.jpg',
    '10120734_TranAnhTu.jpg',
    '10120736_DoTrangTuan.jpg',
]

fs.readdir(directoryPath, function (err, files) {
    if (err) {
        return console.log('Unable to scan directory: ' + err);
    }

    files.forEach(function (file) {
        const oldPath = path.join(directoryPath, file);
        // const result = file.match(/_(.*?)\./);
        // const extractedString = result[1];
        const newName = (index++).toString() + '.jpg'; // Tên mới của tệp


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
