const url = '192.168.1.106:3000';
// const url = '192.168.32.103:3000';
// const url_ras = '192.168.32.103:3000';
const url_ras = '192.168.1.106:3000';
const url_python = '192.168.1.9:8001';
final register = "user/register";
final login = 'user/login';

final changeSimulationDateAPI = '/simulationDate';

final createStudentAPI = 'student/create';
final editStudentAPI = 'student/edit';
final deleteStudentAPI = 'student/delete';
final uploadAvatarAPI = 'student/uploadAvatar';
final uploadVideoAPI = 'student/uploadVideo';

final getAllStudentAPI = 'student/getAll';
final getStudentByModuleIDAPI = 'student/getStudentByModuleID';
final getStudentsByFacultyIDAPI = 'student/getStudentsByFacultyID';

final createLecturerAPI = 'lecturer/createLecturer';
final getAllLecturerAPI = 'lecturer/getAllLecturer';
final getAllLecturerByFacultyIDAPI = 'lecturer/getLecturersByFacultyID';

final getAllSubjectAPI = 'subject/getAll';

final getAllClassAPI = 'class/getAllClass';

final getAllSchoolyearAPI = 'schoolyear/getAll';

final getAllFacultyAPI = 'faculty/getAllFaculty';
final getAllSpecializationsByLecturerIDAPI =
    'faculty/getSpecializationsByLecturerID';
final getAllFacultyByLecturerIDAPI = 'faculty/getFacultyByLecturerID';
final getFacultyByStudentIDAPI = 'faculty/getFacultyByStudentID';

final getAllScheduleStudentWeekAPI = 'student/getAllScheduleWeek';
final getAllScheduleStudentTermAPI = 'student/getAllScheduleTerm';

final getAllScheduleLecturerWeekAPI = 'lecturer/getAllScheduleWeek';
final getAllScheduleLecturerTermAPI = 'lecturer/getAllScheduleTerm';

final getAllScheduleTermAPI = 'admin/getAllScheduleTerm';

final getAllModuleTermByLecturerIDAPI = 'module/getAllModuleTermByLecturerID';

//----------------------------------------------------------------

final getAllAttendanceStudentTermAPI = 'student/getAllAttendanceTerm';

final getAllAttendanceLecturerWeekAPI = 'lecturer/getAllAttendanceWeek';
final getAllAttendanceLecturerTermAPI = 'lecturer/getAllAttendanceTerm';

final getAllAttendanceAdminWeekAPI = 'admin/getAllAttendanceWeek';
final getAllAttendanceAdminTermAPI = 'admin/getAllAttendanceTerm';
