const FacultyModel = require('../models/faculty.model');
const LecturerModel = require('../models/lecturer.model');
const StudentModel = require('../models/student.model');

class FacultyService {
    static async getFacultyByFacultyID(facultyID) {
        try {
            return await FacultyModel.findOne({ facultyID });
        } catch (err) {
            console.log(err);
        }
    }
    
    static async getFacultyByLecturerID(lecturerID) {
        try {
            const lecturer = await LecturerModel.findOne({ lecturerID });
            const facultyID = lecturer.facultyID
            return await FacultyModel.findOne({ facultyID });
        } catch (err) {
            console.log(err);
        }
    }
    
    static async getFacultyByStudentID(studentId) {
        try {
            const student = await StudentModel.findOne({ studentId });
            const specializationID = student.specializationID
            const result  = await FacultyModel.aggregate([
                { $unwind: '$majors' },
                { $unwind: '$majors.specializations' },
                { $match: { 'majors.specializations.specializationID': specializationID } },
                { $group: {
                    _id: '$_id',
                    facultyID: { $first: '$facultyID' },
                    facultyName: { $first: '$facultyName' },
                    majors: { $push: '$majors' }
                }}
              ]);

            const faculty = await FacultyModel.findOne({ facultyID: result[0].facultyID});
            return faculty;
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