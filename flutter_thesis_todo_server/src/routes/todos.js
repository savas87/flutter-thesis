const express = require('express');
const controllers = require("../controllers");
const router = express.Router();

router.get('/getAllTodos', controllers.todos.getAllTodos);
router.post('/createTodo', controllers.todos.createTodo);
router.put('/update/:todoId', controllers.todos.updateTodo);
router.delete('/:todoId', controllers.todos.deleteTodo);


module.exports = router;