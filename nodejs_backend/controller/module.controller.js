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

exports.getAllModuleTermByLecturerID = async (req, res, next) => {
    try {
        console.log(req.body)
        const { lecturerID, semesterID, studentId } = req.body;
        console.log(lecturerID, semesterID, studentId);
        const attendanceList = await ModuleService.getAllModuleTermByLecturerID(lecturerID, semesterID, studentId);
        res.json({ status: true, success: 'getAllModuleTermByLecturerID successfully', data: attendanceList });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};