const ScheduleModel = require("../../models/schedule/schedule.model");
const LecturerModel = require("../../models/lecturer.model");
const ModuleModel = require("../../models/module.model");
const StudentModel = require("../../models/student.model");
const SubjectModel = require("../../models/subject.model");
const RoomModel = require("../../models/room.model");

const ScheduleStudentTermModel = require("../../models/schedule/schedule_student_term.model");

class ScheduleStudentTermService {
  // static async getAllScheduleStudentTerm(studentId) {
  //   try {
  //     const student = await StudentModel.findOne({ studentId: studentId });
  //     const classCode = student.classCode;
  //     console.log("classCode get :" + classCode);

  //     const modules = await ModuleModel.find({ classCode });

  //     const scheduleStudentTerms = [];

  //     for (const module of modules) {
  //       const { moduleID, lecturerID, } = module;

  //       const scheduleModels = await ScheduleModel.find({ moduleID });
  //       const lecturer = await LecturerModel.findOne({ lecturerID });

  //       for (const scheduleModel of scheduleModels) {
  //         const { details, dateStart, dateEnd, classRoomID, dayTerm } = scheduleModel;
  //         const roomName = await RoomModel.findOne({ classRoomID });
  //         console.log("dayTerm.day: " + dayTerm)
  //         const day = dayTerm[0].day;
  //         const time = dayTerm[0].time;
  //         console.log("dayTerm.day: " + day)
  //         console.log("dayTerm.Time: " + time)

  //         const subjectID = module.subjectID;
  //         const subject = await SubjectModel.findOne({ subjectID });
  //         const subjectName = subject.subjectName;
  //         const numberOfCredits = subject.numberOfCredits

  //         const lecturerName = lecturer.lecturerName;

  //         const scheduleStudentTerm = new ScheduleStudentTermModel(day, time, moduleID, subjectName, roomName.roomName, lecturerName, dateStart, dateEnd, numberOfCredits);
  //         scheduleStudentTerms.push(scheduleStudentTerm);


  //       }
  //     }

  //     return scheduleStudentTerms;
  //   } catch (err) {
  //     console.log(err);
  //   }
  // }

  static async getAllScheduleStudentTerm(studentId) {
    try {

      // Tìm các module mà sinh viên đó đang học (module có studentId trong listStudentID)
      const modules = await ModuleModel.find({ listStudentID: studentId });

      if (!modules || modules.length === 0) {
        throw new Error("No modules found for the student");
      }

      const scheduleStudentTerms = [];

      // Duyệt qua từng module
      for (const module of modules) {
        const { moduleID, lecturerID } = module;

        // Tìm lịch học của module đó
        const scheduleModels = await ScheduleModel.find({ moduleID });
        const lecturer = await LecturerModel.findOne({ lecturerID });

        // Duyệt qua từng lịch học của module
        for (const scheduleModel of scheduleModels) {
          const { dayTerms, dateStart, dateEnd, classRoomID } = scheduleModel;

          // Duyệt qua từng chi tiết trong tuần
          for (const dayTerm of dayTerms) {
            const day = dayTerm.day;
            const time = dayTerm.time;

            // Tìm thông tin phòng học dựa trên classRoomID
            const room = await RoomModel.findOne({ classRoomID });
            const roomName = room.roomName;

            // Tìm thông tin môn học dựa trên subjectID
            const subjectID = module.subjectID;
            const subject = await SubjectModel.findOne({ subjectID });
            const subjectName = subject.subjectName;
            const numberOfCredits = subject.numberOfCredits;

            // Lấy thông tin giáo viên dạy
            const lecturerName = lecturer.lecturerName;

            // Tạo đối tượng lịch học và thêm vào danh sách
            const scheduleStudentTerm = new ScheduleStudentTermModel(
              day,
              time,
              moduleID,
              subjectName,
              roomName,
              lecturerName,
              dateStart,
              dateEnd,
              numberOfCredits
            );

            scheduleStudentTerms.push(scheduleStudentTerm);
          }

        }
      }

      return scheduleStudentTerms;
    } catch (err) {
      console.error('Error retrieving schedule:', err);
      throw err;
    }
  }




}
module.exports = ScheduleStudentTermService;