const FacultyService = require('../services/faculty.service');

exports.getAllFaculty = async (req, res, next) => {
  try {
    const facultyList = await FacultyService.getAllFaculty();
    res.json({ status: true, success: 'Get all faculty successfully', data: facultyList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};

exports.getFacultyByLecturerID = async (req, res, next) => {
  try {
    const {lecturerID} = req.body;
    const facultyList = await FacultyService.getFacultyByLecturerID(lecturerID);
    res.json({ status: true, success: 'getFacultyByLecturerID successfully', data: facultyList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};

exports.getFacultyByStudentID = async (req, res, next) => {
  try {
    const {studentId} = req.body;
    const facultyList = await FacultyService.getFacultyByStudentID(studentId);
    res.json({ status: true, success: 'getFacultyByStudentID successfully', data: facultyList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};

exports.getSpecializationsByLecturerID = async (req, res, next) => {
  try {
    const {lecturerID} = req.body;
    const specializationList = await FacultyService.getSpecializationsByLecturerID(lecturerID);
    res.json({ status: true, success: 'getSpecializationsByLecturerID successfully', data: specializationList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};