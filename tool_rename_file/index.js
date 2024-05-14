const fs = require('fs');
const path = require('path');

var index = 0;
const directoryPath = 'D:/DHCQ-2020-2024/2023-2024_Ky 2/DATN/Project/GraduationProject/nodejs_backend/public/images/default/avatar/New folder';

const arr = [
    '10120603_DoQuynhAnh',
    '12520088_LeVietAnh',
    '10120766_NguyenMinhAnh',
    '10120620_NguyenMinhDoanh',
    '10120623_NguyenThaiDuong',
    '10120626_LeHaiDang',
    '10120635_PhamThanhHang',
    '10120741_LuuHuyHoang',
    '10120745_NguyenManhHung',
    '10120056_LeNgocLanh',
    '10120792_ThanThiMyLinh',
    '10120748_TrinhThiLinh',
    '10120669_DaoNgocLong',
    '10120674_NguyenThiCamLy',
    '10120678_VuNgocMinh',
    '10120683_DangNgocNhan',
    '10120773_NguyenThiNgocPhuong',
    '10120701_LeHoangSon',
    '10120707_NguyenVanThai',
    '10120734_TranAnhTu',
    '10120736_DoTrangTuan',
]

// const arr = [
//     '11421327_BiTranQuynhAnh',
//     '11421103_DaoThiNgocAnh',
//     '11421125_TranThiLanAnh',
//     '11421180_VuThiThuyDuong',
//     '11421220_LeThiTraGiang',
//     '11421124_LeThuHa',
//     '11421224_NguyenThiThuHa',
//     '11421131_NguyenThuHa',
//     '11421230_TruongThiThuHao',
//     '11421231_PhamThiKieuHay',
//     '11421046_LaThiThuHien',
//     '11421010_DangNgocHoa',
//     '11421016_NguyenThiHoai',
//     '11421130_TranThiHoai',
//     '11421312_DangThuHue',
//     '10921168_NguyenThiHue',
//     '11421177_DangNgocHuyen',
//     '11421237_DoanThiThanhHuyen',
//     '11421236_VuThiMaiHuyen',
//     '11421241_TranThiLe',
//     '10721308_NguyenThuyLinh',
//     '11321152_TranNgocLinh',
//     '11421244_VuThiThuyLinh',
//     '10721092_PhamThiLua',
//     '11420119_NguyenThiHoaMy',
//     '11421278_PhamHangNga',
//     '11321107_NguyenThiNgan',
//     '11421064_NguyenThiQuynhNgoc',
//     '11421253_DoThiPhiNhung',
//     '10721306_NguyenThiKimOanh',
//     '10921248_NguyenThiPhuong',
//     '11421186_NguyenThiPhuongThao',
//     '10721148_LeHongThom',
//     '11421068_CaoThiMinhThuy',
//     '11421128_KhucThiNgocThu',
//     '11421269_NguyenThiHuyenTrang',
//     '11421300_TranThiThuyTrang'
// ]

fs.readdir(directoryPath, function (err, files) {
    if (err) {
        return console.log('Unable to scan directory: ' + err);
    }

    files.forEach(function (file) {
        const oldPath = path.join(directoryPath, file);
        // const result = file.match(/_(.*?)/./);
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
