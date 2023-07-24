const mongoose = require('mongoose');
const {Schema, model} = mongoose;

const todoSchema = new Schema({
    title: String,
    description: String,
    createdBy: String,
    completed: Boolean,
    createAt: { type: Date, default: Date.now() }
});

const Todo = model('Todo', todoSchema);

module.exports = Todo;