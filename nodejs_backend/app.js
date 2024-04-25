
const bodyParser = require("body-parser")
const UserRoute = require("./routes/user.routes");

const StudentRoute = require('./routes/student.router');
const LecturerRoute = require('./routes/lecturer.router');
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

app.use(bodyParser.json())

app.use("/user", UserRoute);

app.use("/student", StudentRoute);
app.use("/lecturer", LecturerRoute);

app.use('/images', LoadImageRoute);






module.exports = app;