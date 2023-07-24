// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_thesis_todo_app/screens/todo_list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/messageService.dart';

class AddTodoItem extends StatefulWidget {
  final Map? todo;
  const AddTodoItem({super.key, this.todo});

  @override
  State<AddTodoItem> createState() => _AddTodoItemState();
}

class _AddTodoItemState extends State<AddTodoItem> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEditing = false;
  bool isCompleted = false;
  bool isTitleEmpty = false;
  bool isDescriptionEmpty = false;

  late final String? token;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEditing = true;
      final title = todo['title'];
      final description = todo['description'];
      final completed = todo['completed'];
      titleController.text = title;
      descriptionController.text = description;
      isCompleted = completed;
      isTitleEmpty = titleController.text.isEmpty;
      isDescriptionEmpty = titleController.text.isEmpty;
    }
    setToken();
    print(isTitleEmpty);
  }

  void setToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('refreshToken');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Todo Bearbeiten' : 'Todo Hinzufügen'),
        backgroundColor: Colors.pink,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Beschreibung'),
            minLines: 5,
            maxLines: 8,
          ),
          CheckboxListTile(
              title: const Text('Completed'),
              value: isCompleted,
              onChanged: (value) {
                setState(() {
                  isCompleted = value!;
                });
              }),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: isEditing ? updateTodo : submit,
            child: Text(isEditing ? 'Update' : 'Hinzufügen'),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () => navigateToListPage(''),
              child: const Text('Zurück'))
        ],
      ),
    );
  }

  void backToList() {}
  Future<void> updateTodo() async {
    final todo = widget.todo;
    if (todo == null) {
      print('Keine Todos zum updated vorhand');
      return;
    }

    final id = todo['_id'];
    final completed = isCompleted;
    final title = titleController.text;
    final description = descriptionController.text;

    final requestBody = {
      "title": title,
      "description": description,
      "completed": completed,
    };

    final url = "http://localhost:3000/api/todos/update/$id";
    final uri = Uri.parse(url);

    final response = await http.put(
      uri,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ShowMessages().showSuccess("Todo update erfolgreich", context);
      navigateToListPage(token!);
      titleController.text = '';
      descriptionController.text = '';
    } else {
      ShowMessages().showFailed(
          "Todo konnte nicht erstellt werden: ${response.statusCode}", context);
    }
  }

  Future<void> submit() async {
    final title = titleController.text;
    final description = descriptionController.text;

    final requestBody = {
      "title": title,
      "description": description,
      "completed": false,
    };

    const url = "http://localhost:3000/api/todos/createTodo";
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );
    if (titleController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty) {
      if (response.statusCode == 201) {
        print(titleController.text.isNotEmpty);
        ShowMessages().showSuccess("Todo erfolgreich erstellt", context);
        navigateToListPage(token!);
        titleController.text = '';
        descriptionController.text = '';
      } else {
        ShowMessages().showFailed(
            "Todo konnte nicht erstellt werden: ${response.statusCode}",
            context);
      }
    } else {
      ShowMessages().showFailed(
          "Todo konnte nicht erstellt werden: ${response.statusCode}", context);
    }
  }

  void navigateToListPage(String token) {
    final route = MaterialPageRoute(
      builder: (context) => TodoList(token: token),
    );
    Navigator.push(context, route);
  }
}
