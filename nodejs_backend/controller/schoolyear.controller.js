const SchoolyearService = require('../services/schoolyear.service');

exports.getAll = async (req, res, next) => {
  try {
    const schoolyearList = await SchoolyearService.getAll();
    res.json({ status: true, success: 'Get all schoolyears successfully', data: schoolyearList });
  } catch (err) {
    console.log("---> err -->", err);
    next(err);
  }
};