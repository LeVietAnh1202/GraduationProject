const ScheduleModel = require("../../models/schedule/schedule.model");
const LecturerModel = require("../../models/lecturer.model");
const ModuleModel = require("../../models/module.model");
const SubjectModel = require("../../models/subject.model");
const RoomModel = require("../../models/room.model");

const AttendanceTermModel = require("../../models/schedule/schedule_admin_term.model");
const ScheduleTermModel = require("../../models/schedule/schedule_admin_term.model");

class ScheduleTermService {
  // static async getAttendanceAdminTerm(lecturerID,  semesterID) {
  //   try {
  //     const modules = await ModuleModel.find({ lecturerID: lecturerID, semesterID: semesterID });

  //     const scheduleAdminTerms = [];

  //     for (const module of modules) {
  //       const { moduleID } = module;

  //       const scheduleModels = await ScheduleModel.find({ moduleID });
  //       const lecturer = await LecturerModel.findOne({ lecturerID });
  //       const lecturerName = lecturer.lecturerName;

  //       for (const scheduleModel of scheduleModels) {
  //         const { dateStart, dateEnd, classRoomID, dayTerms } = scheduleModel;
  //         const roomName = await RoomModel.findOne({ classRoomID });
  //         for (const dayTerm of dayTerms) {
  //           // const day = dayTerm.day;
  //           // const time = dayTerm.time;
  //           const weekTimeStart = dayTerm.weekTimeStart;
  //           const weekTimeEnd = dayTerm.weekTimeEnd;
  //           const subject = await SubjectModel.findOne({ subjectID });
  //           const subjectName = subject.subjectName;
  //           const numberOfCredits = subject.numberOfCredits;

  //           const scheduleAdminTerm = new ScheduleAdminTermModel( moduleID, subjectName, lecturerName, roomName.roomName, dateStart, dateEnd, numberOfCredits, weekTimeStart, weekTimeEnd);
  //           scheduleAdminTerms.push(scheduleAdminTerm);
  //         }
  //       }
  //     }

  //     return scheduleAdminTerms;
  //   } catch (err) {
  //     console.log(err);
  //   }
  // }

  
  //----------------------------------------------------------------------
  static async getAllScheduleTerm(lecturerID, semesterID) {
    try {
      // Tìm tất cả các module của giảng viên trong học kỳ hiện tại
      const modules = await ModuleModel.find({ lecturerID, semesterID });
      if (!modules || modules.length === 0) {
        console.warn(`No modules found for lecturer with ID ${lecturerID} and semester ID ${semesterID} and subject ID ${subjectID}`);
        return [];
      }

      const scheduleTerms = [];

      for (const module of modules) {
        const { moduleID } = module;

        // Tìm tất cả các lịch trình của module
        const scheduleModels = await ScheduleModel.find({ moduleID });
        if (!scheduleModels || scheduleModels.length === 0) {
          console.warn(`No schedules found for module with ID ${moduleID}`);
          continue;
        }

        // Tìm thông tin giảng viên
        const lecturer = await LecturerModel.findOne({ lecturerID });
        if (!lecturer) {
          console.warn(`Lecturer with ID ${lecturerID} not found`);
          continue;
        }
        const lecturerName = lecturer.lecturerName;

        for (const scheduleModel of scheduleModels) {
          const { dateStart, dateEnd, classRoomID, dayTerms } = scheduleModel;

          // Tìm thông tin phòng học
          const room = await RoomModel.findOne({ classRoomID });
          if (!room) {
            console.warn(`Room with ID ${classRoomID} not found`);
            continue;
          }

          for (const dayTerm of dayTerms) {
            const { weekTimeStart, weekTimeEnd } = dayTerm;
            const day = dayTerm.day;
            const time = dayTerm.time;
            // Tìm thông tin môn học
            const subject = await SubjectModel.findOne({ subjectID: module.subjectID });
            if (!subject) {
              console.warn(`Subject with ID ${module.subjectID} not found`);
              continue;
            }
            const subjectName = subject.subjectName;
            const numberOfCredits = subject.numberOfCredits;

            // Tạo đối tượng ScheduleTermModel
            const scheduleTerm = new ScheduleTermModel(
              day,
              time,
              moduleID,
              subjectName,
              lecturerName,
              room.roomName,
              dateStart,
              dateEnd,
              numberOfCredits,
              weekTimeStart,
              weekTimeEnd
            );
            scheduleTerms.push(scheduleTerm);
          }
        }
      }

      return scheduleTerms;
    } catch (err) {
      console.error(err);
      throw err; // Ném lỗi để xử lý ở cấp cao hơn nếu cần thiết
    }
  }
}
module.exports = ScheduleTermService;