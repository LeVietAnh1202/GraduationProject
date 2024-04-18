const LecturerModel = require("../models/lecturer.model");
class LecturerService {
    static async createLecturer(lecturerId, lecturerName, gender, birthDate) {
        try {
            const createLecturer = new StudentModel({ lecturerId, lecturerName, gender, birthDate });
            return await createLecturer.save();
        } catch (err) {
            throw err;
        }
    }
    static async getLecturerByLecturerID(lecturerId) {
        console.log('HTHI LecturerID:', lecturerId);
        try {
            return await LecturerModel.findOne({ lecturerId });
        } catch (err) {
            console.log(err);
        }
    }
    static async getAllLecturer() {
        try {
            return await LecturerModel.find();
        } catch (err) {
            console.log(err);
        }
    }


}

module.exports = LecturerService;