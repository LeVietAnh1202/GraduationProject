const ClassService = require('../services/class.service');

exports.createClass = async (req, res, next) => {
  try {
    const { classCode, className } = req.body;
    const duplicate = await ClassService.getClassByClassCode(classCode);
    if (duplicate) {
      return res.json({ status: true, success: 'ClassCode already exists' });
    }
    await ClassService.createClass(classCode, className);
    res.json({ status: true, success: 'Create class successfully' });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};

exports.getAllClass = async (req, res, next) => {
  try {
    const classList = await ClassService.getAllClass();
    res.json({ status: true, success: 'Get all classes successfully', data: classList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};