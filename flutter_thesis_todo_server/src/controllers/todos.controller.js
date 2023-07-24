const models = require("../models");

const getAllTodos = async (req,res) => {
    try {
        const todos = await models.Todo.find({});
        res.status(200).json({
          message: 'Alle Todos',
          todos
        });
      } catch (err) {
        res.status(500).json({ err });
      }
}

const createTodo = (req, res) => {
    const { title, description, createdBy } = req.body;

    var toDoAdd = new models.Todo({
        title: title,
        description: description,
        createdBy: createdBy,
        completed: false
    });
    
    toDoAdd.save().then((todo) => res.status(201).json({message: 'Todo wurde erstellt', todo}))
}

const deleteTodo = async (req, res) => {
    const { todoId } = req.params;
    try {
      const todo = await models.Todo.findByIdAndDelete(todoId);
      if (todo) {
        res.status(200).json({ message: "Gelöscht" });
      } else {
        res.status(404).json({ message: "Todo nicht gefunden" });
      }
    } catch (err) {
      res.status(500).json({ err });
    }
}

const updateTodo = async(req, res) => {
    const { todoId } = req.params;
    const { title, description, createdBy, completed } = req.body;
    try {
        const updatedTodo = await models.Todo.findByIdAndUpdate(
          todoId,
          {
            title,
            description,
            createdBy,
            completed,
          },
          { new: true }
        );
    
        if (updatedTodo) {
          res.status(200).json({ message: 'Todo update erfolgreich', todo: updatedTodo });
        } else {
          res.status(404).json({ message: 'Todo nicht gefunden' });
        }
      } catch (err) {
        res.status(500).json({ err });
      }

}


module.exports = {
   createTodo, 
   getAllTodos,
   deleteTodo,
   updateTodo
};