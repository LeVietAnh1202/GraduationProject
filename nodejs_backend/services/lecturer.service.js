const LecturerModel = require("../models/lecturer.model");
class LecturerService {
    static async createLecturer(lecturerID, lecturerName, gender, birthDate) {
        try {
            const createLecturer = new StudentModel({ lecturerID, lecturerName, gender, birthDate });
            return await createLecturer.save();
        } catch (err) {
            throw err;
        }
    }

    static async getAllLecturer() {
        try {
            return await LecturerModel.find();
        } catch (err) {
            console.log(err);
        }
    }

    static async getLecturerByLecturerID(lecturerID) {
        console.log('HTHI LecturerID:', lecturerID);
        try {
            return await LecturerModel.findOne({ lecturerID });
        } catch (err) {
            console.log(err);
        }
    }

    static async getLecturersByFacultyID(facultyID) {
        try {
            const lecturers = await LecturerModel.find({facultyID: facultyID});
            return lecturers;
        } catch (err) {
            console.log(err);
        }
    }


}

module.exports = LecturerService;