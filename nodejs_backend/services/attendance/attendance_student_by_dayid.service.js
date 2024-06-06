const ScheduleModel = require("../../models/schedule/schedule.model");
const ModuleModel = require("../../models/module.model");
const AttendanceModel = require("../../models/attendance.model");
const LecturerModel = require("../../models/lecturer.model");
const RoomModel = require("../../models/room.model");
const SubjectModel = require("../../models/subject.model");
const AttendanceStudentByDayIDModel = require("../../models/attendance/attendance_student_by_dayid.model");

class AttendanceStudentByDayIDService {
    static async getAttendanceStudentByDayID(studentId, dayID) {
        try {
            // Query to find the schedule containing the dayID in its details.weekDetails
            const schedule = await ScheduleModel.findOne(
                { "details.weekDetails.dayID": dayID },
                {
                    moduleID: 1,
                    classRoomID: 1,
                    details: { $elemMatch: { "weekDetails.dayID": dayID } }
                }
            ).exec();

            if (!schedule) {
                throw new Error('Schedule not found');
            }

            const { moduleID, classRoomID, details } = schedule;

            // Extract the relevant weekDetails
            const matchingWeekDetails = details[0]?.weekDetails.find(weekDetail => weekDetail.dayID === dayID);
            if (!matchingWeekDetails) {
                throw new Error('WeekDetails not found');
            }
            const { day, time } = matchingWeekDetails;

            // Find the module details using moduleID
            const module = await ModuleModel.findOne({ moduleID }).exec();
            if (!module) {
                throw new Error('Module not found');
            }

            const { lecturerID, subjectID } = module;

            // Parallelize independent queries
            const [lecturer, subject, attendanceDoc] = await Promise.all([
                LecturerModel.findOne({ lecturerID }).exec(),
                SubjectModel.findOne({ subjectID }).exec(),
                AttendanceModel.findOne({ studentId, dayID }).exec()
            ]);

            if (!lecturer) {
                throw new Error('Lecturer not found');
            }
            if (!subject) {
                throw new Error('Subject not found');
            }
            const room = await RoomModel.findOne({ classRoomID });
            const roomName = room.roomName;

            const lecturerName = lecturer.lecturerName;
            const subjectName = subject.subjectName;
            const attendance = attendanceDoc ? attendanceDoc.attendance : [];

            // Construct and return the attendanceStudentTermModel
            const attendanceStudentTermModel = new AttendanceStudentByDayIDModel(
                moduleID,
                roomName,
                lecturerName,
                subjectName,
                attendance,
                day,
                time
            );

            return attendanceStudentTermModel;
        } catch (error) {
            console.error('Error retrieving module details:', error.message);
            throw error; // Re-throw the error after logging it
        }
    }
}

module.exports = AttendanceStudentByDayIDService;