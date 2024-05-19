const SubjectService = require('../services/subject.service');

exports.getSubjectsByLecturerID = async (req, res, next) => {
  try {
    const { semesterID, lecturerID } = req.body;
    const subjectList = await SubjectService.getSubjectsByLecturerID(semesterID, lecturerID);
    console.log(subjectList)
    res.json({ status: true, success: 'Get subjects by lecturer ID successfully', data: subjectList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};

exports.getAllSubject = async (req, res, next) => {
  try {
    const subjectList = await SubjectService.getAllSubject();
    res.json({ status: true, success: 'Get all subjects successfully', data: subjectList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};