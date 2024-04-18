const SubjectModel = require('../models/subject.model');

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
        console.log('HTHI SubjectID:', subjectID);
        try {
            return await SubjectModel.findOne({ subjectID });
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