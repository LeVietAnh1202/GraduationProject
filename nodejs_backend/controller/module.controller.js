const ModuleService = require('../services/module.service');

exports.createModule = async (req, res, next) => {
    try {
        const { moduleID, subjectID, listStudentID, lecturerID } = req.body;
        const duplicate = await ModuleService.getModuleByModuleID(moduleID);
        if (duplicate) {
            return res.json({ status: true, success: 'ModuleID already exists' });
        }
        await ModuleService.createModule(moduleID, subjectID, listStudentID, lecturerID, semesterID);
        res.json({ status: true, success: 'Create module successfully' });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

exports.getAllModule = async (req, res, next) => {
    try {
        const moduleList = await ModuleService.getAllModule();
        res.json({ status: true, success: 'Get all modules successfully', data: moduleList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};