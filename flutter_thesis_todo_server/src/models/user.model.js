const mongoose = require('mongoose');
const {Schema, model} = mongoose;

const userSchema = new Schema({
    username: {type: String, unique: true},
    password: {type: String, unique: false}
});

const User = model('User', userSchema);

module.exports = User;