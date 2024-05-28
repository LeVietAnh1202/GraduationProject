const ScheduleModel = require("./../models/schedule/schedule.model");
const LecturerModel = require("./../models/lecturer.model");
const ModuleModel = require("./../models/module.model");
const StudentModel = require("./../models/student.model");
const SubjectModel = require("./../models/subject.model");
const AttendanceModel = require("./../models/attendance.model");
const RoomModel = require("./../models/room.model");

class CheckAttendanceSocketIO {


    static async checkAttendanceSocketIO(io, client) {
        client.on('attendance', async data => {
            console.log(data);

            client.emit('dataReceived', 'Data received by server');

            io.emit('attendance', data);
            const fingerID = data.fingerID;
            console.log(fingerID);

            try {
                const student = await StudentModel.findOne({ fingerprintID: fingerID });
                if (!student) {
                    client.emit('studentNotExist', 'Van tay khong ton tai');
                }
                else {
                    const classCode = student.classCode;
                    const modules = await ModuleModel.find({ classCode });

                    const scheduleStudentWeeks = [];

                    var attendanced = false;
                    for (const module of modules) {
                        const { moduleID } = module;

                        const scheduleModels = await ScheduleModel.find({ moduleID });

                        for (const scheduleModel of scheduleModels) {
                            const { details } = scheduleModel;

                            for (const week of details) {
                                const { weekDetails } = week;
                                const weekTimeStart = new Date(week.weekTimeStart);
                                const weekTimeEnd = new Date(week.weekTimeEnd);
                                for (const weekDetail of weekDetails) {
                                    const { day, time, dayID } = weekDetail;
                                    const numberOfDays = parseInt(day, 10);
                                    const [hours, minutes] = calculateTime(time).split(':');
                                    console.log('weekTimeStart: ' + weekTimeStart.toLocaleString('vi-VN', { hour12: false, timeZone: 'Asia/Ho_Chi_Minh' }))
                                    console.log('weekTimeEnd: ' + weekTimeEnd.toLocaleString('vi-VN', { hour12: false, timeZone: 'Asia/Ho_Chi_Minh' }))
                                    weekTimeStart.setDate(weekTimeStart.getDate() + numberOfDays - 2);
                                    weekTimeStart.setHours(hours);
                                    weekTimeStart.setMinutes(minutes);

                                    const timeStartSession = new Date(weekTimeStart);
                                    const timeStartSessionStr = timeStartSession.toLocaleString('vi-VN', { hour12: false, timeZone: 'Asia/Ho_Chi_Minh' });
                                    console.log('timeStartSessionStr: ' + timeStartSessionStr);

                                    const beforeTimeStartSession = new Date(timeStartSession.getTime() - 30 * 60000);
                                    const beforeTimeStartSessionStr = beforeTimeStartSession.toLocaleString('vi-VN', { hour12: false, timeZone: 'Asia/Ho_Chi_Minh' });
                                    console.log('beforeTimeStartSessionStr: ' + beforeTimeStartSessionStr);

                                    const afterTimeStartSession = new Date(timeStartSession.getTime() + 30 * 60000);
                                    const afterTimeStartSessionStr = afterTimeStartSession.toLocaleString('vi-VN', { hour12: false, timeZone: 'Asia/Ho_Chi_Minh' });
                                    console.log('afterTimeStartSessionStr: ' + afterTimeStartSessionStr);

                                    const currentTime = new Date(global.currentTime)
                                    if (currentTime >= beforeTimeStartSession && currentTime <= afterTimeStartSession) {
                                        const attendance = await AttendanceModel.findOne({ studentId: student.studentId, dayID: dayID });
                                        var attendanceValue;
                                        if (currentTime >= beforeTimeStartSession && currentTime <= timeStartSession) {
                                            attendanceValue = 2
                                        }
                                        else if (currentTime > timeStartSession && currentTime <= afterTimeStartSession) {
                                            attendanceValue = 1
                                        }

                                        attendanced = true;

                                        console.log(student.studentId + ' *** ' + dayID);
                                        // Kiểm tra xem có bản ghi điểm danh nào không
                                        if (!attendance) {
                                            // Dữ liệu mới cần thêm vào
                                            const newAttendanceData = {
                                                studentId: student.studentId,
                                                dayID: dayID,
                                                attendance: attendanceValue,
                                            };

                                            // Sử dụng hàm create để tạo mới một bản ghi
                                            AttendanceModel.create(newAttendanceData)
                                                .then((newAttendance) => {
                                                    console.log('Bản ghi mới đã được tạo:', newAttendance);
                                                    client.emit('studentNotExist', '1');
                                                })
                                                .catch((error) => {
                                                    console.error('Lỗi khi tạo mới bản ghi:', error);
                                                });
                                            // Sau khi cập nhật, bạn có thể làm các thao tác khác nếu cần
                                            console.log('Đã thêm giá trị mới cho attendance.');
                                        } else {
                                            client.emit('studentNotExist', '2');
                                            console.log('Đã điểm danh');
                                        }
                                    } else {

                                    }
                                }
                            }
                        }
                    }
                    if (!attendanced) {
                        client.emit('studentNotExist', '0');
                        console.log('Hiện tại không có lịch học');
                    }
                    // return scheduleStudentWeeks;
                }

            } catch (err) {
                console.log(err);
            }
        });
    }
}

function calculateTime(time) {
    const [startHour, endHour] = time.split('-').map(Number);
    var startTime = '';
    if (startHour == '1') startTime = '07:15'
    if (startHour == '8') startTime = '13:35'
    return startTime;
}

module.exports = CheckAttendanceSocketIO;