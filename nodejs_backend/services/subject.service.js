const SubjectModel = require('../models/subject.model');
const ModuleModel = require('../models/module.model');

class SubjectService {
    static async createSubject(subjectID, subjectName, numberOfCredits, numberOfLessons) {
        try {
            const createSubject = new SubjectModel({ subjectID, subjectName, numberOfCredits, numberOfLessons });
            return await createSubject.save();
        } catch (err) {
            throw err;
        }
    }

    static async getSubjectBySubjectID(subjectID) {
        try {
            return await SubjectModel.findOne({ subjectID });
        } catch (err) {
            console.log(err);
        }
    }

    static async getSubjectsByLecturerID(semesterID, lecturerID) {
        try {
            console.log(semesterID + lecturerID);
            const modules = await ModuleModel.find({ semesterID: semesterID, lecturerID: lecturerID });

            // Sử dụng Set để loại bỏ các subjectID trùng nhau
            const subjectIDSet = new Set();
            for (const module of modules) {
                subjectIDSet.add(module.subjectID);
            }

            // Chuyển đổi Set thành mảng để trả về
            const uniqueSubjectIDs = Array.from(subjectIDSet);
            const subjects = SubjectModel.find({ subjectID: {$in: uniqueSubjectIDs}}).select('subjectID subjectName');;

            return subjects;
        } catch (err) {
            console.log(err);
        }
    }

    static async getAllSubject() {
        try {
            return await SubjectModel.find();
        } catch (err) {
            console.log(err);
        }
    }
}

module.exports = SubjectService;