import 'package:flutter_todo_app/constant/config.dart';
import 'package:flutter_todo_app/constant/number.dart';

const String trangChu = 'Trang chủ';
const String quanLyDanhMuc = 'Quản lý danh mục';
const String danhMucSinhVien = 'Danh mục sinh viên';
const String danhMucGiangVien = 'Danh mục giảng viên';
const String quanLyLichHoc = 'Quản lý lịch học';
const String quanLyDinhDanh = 'Quản lý định danh';
const String quanLyDiemDanh = 'Quản lý điểm danh';
const String danhMucKhoa = 'Danh mục khoa';
const String danhMucNganh = 'Danh mục ngành';
const String danhMucChuyenNganh = 'Danh mục chuyên ngành';

String studentWeek = '${Role.student.toString()}Week';
String studentTerm = '${Role.student.toString()}Term';
String lecturerTerm = '${Role.lecturer.toString()}Term';
String adminTerm = '${Role.admin.toString()}Term';
String aaoTerm = '${Role.aao.toString()}Term';

const String URLNodeJSServer = 'http://${url}';
const String URLPythonServer = 'http://${url_python}';
const String URLNodeJSServer_RaspberryPi = 'http://${url_ras}';

const String URLNodeJSServer_RaspberryPi_Images =
    'http://${url_ras}/images/default';
const String URLNodeJSServer_RaspberryPi_Videos =
    'http://${url_ras}/videos/default';
const String URLNodeJSServer_Python_AttendanceImages =
    'http://${url_ras}/images/attendance_images';

const String URLNodeJSServer_Python_Images =
    'http://${url_python}/public/images';
const String URLNodeJSServer_Python_Images_2 = 'http://${url_python}/train_img';
const String URLNodeJSServer_Python_Images_3 =
    'http://${url_python}/aligned_img';
const String URLNodeJSServer_Python_Videos =
    'http://${url_python}/public/videos';

const String URLVideoPath = 'videos/default';

Map<String, Role> roleMap = {
  "admin": Role.admin,
  "aao": Role.aao,
  "sinhvien": Role.student,
  "giangvien": Role.lecturer
};
    
// const roleAdmin = "admin";
// const roleAao = "aao";
// const roleLecturer = "lecturer";
// const roleStudent = "student";
