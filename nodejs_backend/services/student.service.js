const StudentModel = require("../models/student.model");
class StudentService {
    static async createStudent(studentId, studentName, classCode, gender, birthDate, avatar) {
        try {
            const createStudent = new StudentModel({ studentId, studentName, classCode, gender, birthDate, avatar });
            return await createStudent.save();
        } catch (err) {
            throw err;
        }
    }
    static async getStudentByStudentID(studentId) {
        console.log('HTHI StudenID:', studentId);
        try {
            return await StudentModel.findOne({ studentId });
        } catch (err) {
            console.log(err);
        }
    }
    static async getAllStudent() {
        try {
            return await StudentModel.find();
        } catch (err) {
            console.log(err);
        }
    }


}

module.exports = StudentService;