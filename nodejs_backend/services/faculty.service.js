const FacultyModel = require('../models/faculty.model');
const LecturerModel = require('../models/lecturer.model');

class FacultyService {
    static async getFacultyByFacultyID(facultyID) {
        try {
            return await FacultyModel.findOne({ facultyID });
        } catch (err) {
            console.log(err);
        }
    }

    static async getSpecializationsByLecturerID(lecturerID) {
        try {
            const lecturer = await LecturerModel.findOne({ lecturerID });
            const faculty = await FacultyModel.findOne({ facultyID: lecturer.facultyID });

            if (!faculty) {
                throw new Error('Faculty not found');
            }

            const specializationIDs = faculty.majors.flatMap(major =>
                major.specializations.map(specialization => ({
                    specializationID: specialization.specializationID,
                    specializationName: specialization.specializationName
                }))
            );

            return specializationIDs;
        } catch (err) {
            console.error('Error retrieving specializations:', err.message);
            return []; // Return an empty array or handle the error as needed
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