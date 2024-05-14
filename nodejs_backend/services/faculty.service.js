const FacultyModel = require('../models/faculty.model');

class FacultyService {
    static async getFacultyByFacultyID(facultyID) {
        try {
            return await FacultyModel.findOne({ facultyID });
        } catch (err) {
            console.log(err);
        }
    }

    static async getAllFaculty() {
        try {
            var abc = await FacultyModel.find();
            console.log(abc);
            return abc;
        } catch (err) {
            console.log(err);
        }
    }
}

module.exports = FacultyService;