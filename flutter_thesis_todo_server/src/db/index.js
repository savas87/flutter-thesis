const mongoose = require('mongoose');
mongoose.Promise = global.Promise;

async function connectToDatabase() {
    try {

        const connectionString = `mongodb+srv://user1:pass1@cluster0.3zd1imz.mongodb.net/`;
        await mongoose.connect(connectionString, {
            serverSelectionTimeoutMS: 5000
        });
        console.log('Connected to database');
    } catch (e) {
        console.log('error: '+e);
    }
}

module.exports = connectToDatabase;