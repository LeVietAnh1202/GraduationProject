const SubjectService = require('../services/subject.service');

exports.getAllSubject = async (req, res, next) => {
  try {
    const subjectList = await SubjectService.getAllSubject();
    res.json({ status: true, success: 'Get all subjects successfully', data: subjectList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};