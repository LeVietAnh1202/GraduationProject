const SubjectService = require('../services/subject.service');

exports.createSubject = async (req, res, next) => {
  try {
    const { subjectID, subjectName, numberOfCredits, numberOfLessons } = req.body;
    const duplicate = await SubjectService.getSubjectBySubjectID(subjectID);
    if (duplicate) {
      return res.json({ status: true, success: 'SubjectID already exists' });
    }
    await SubjectService.createSubject(subjectID, subjectName, numberOfCredits, numberOfLessons);
    res.json({ status: true, success: 'Create subject successfully' });
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