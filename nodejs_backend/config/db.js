const mongoose = require('mongoose');
// mongoose.set('debug', true);


const connection = mongoose.createConnection(`mongodb+srv://project:doanh2002@master.lbqzguz.mongodb.net/ToDoDB`).on('open', () => { console.log("MongoDB Connected"); }).on('error', () => {
    console.log("MongoDB Connection error");
});


module.exports = connection;