
const bodyParser = require("body-parser")
const UserRoute = require("./routes/user.routes");

const AdminRoute = require('./routes/admin.router');

const StudentRoute = require('./routes/student.router');
const LecturerRoute = require('./routes/lecturer.router');
const ClassRoute = require('./routes/class.router');
const SchoolyearRoute = require('./routes/schoolyear.router');
const FacultyRoute = require('./routes/faculty.router');
const ScheduleRoute = require('./routes/schedule.router');
const SubjectRoute = require('./routes/subject.router');
const ModuleRoute = require('./routes/module.router');
const AttendanceRoute = require('./routes/attendance.router');
const LoadImageRoute = require('./routes/load_image.router');
const path = require('path');

const express = require('express')
const swaggerUI = require('swagger-ui-express')
const YAML = require('yamljs')
const swaggerDoc = YAML.load('./swagger.yaml')

const app = express();
app.use(express.json())
const cors = require('cors');

app.use(cors())
// Đặt thư mục static là 'public'
app.use(express.static(path.join(__dirname, 'public')));

app.use('/docs', swaggerUI.serve, swaggerUI.setup(swaggerDoc))
app.get('/health', (_req, res) => {
    res.status(200).json({
        health: 'Ok'
    })
})

app.post('/simulationDate', (_req, res) => {
    const {simulationDate} = _req.body
    global.currentTime = simulationDate
    res.json({ status: true, message: 'Thay đổi thời gian mô phỏng thành công.' });
});

app.use(bodyParser.json())

app.use("/user", UserRoute);

app.use("/admin", AdminRoute);

app.use("/student", StudentRoute);
app.use("/lecturer", LecturerRoute);
app.use("/class", ClassRoute);
app.use("/schoolyear", SchoolyearRoute);
app.use("/faculty", FacultyRoute);
app.use("/schedule", ScheduleRoute);
app.use("/subject", SubjectRoute);
app.use("/module", ModuleRoute);
app.use("/attendance", AttendanceRoute);

app.use('/images', LoadImageRoute);

module.exports = app;