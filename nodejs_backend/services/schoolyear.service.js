const SchoolyearModel = require('../models/schoolyear.model');

class SchoolyearService {
  static async getAll() {
    try {
      return await SchoolyearModel.find();
    } catch (err) {
      console.log(err);
    }
  }
}

module.exports = SchoolyearService;