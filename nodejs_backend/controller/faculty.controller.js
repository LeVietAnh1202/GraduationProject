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