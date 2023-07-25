// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thesis_todo_app/services/routingService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../services/messageService.dart';

class TodoList extends StatefulWidget {
  final token;
  const TodoList({@required this.token, super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isLoading = true;
  List items = [];
  bool isChecked = false;
  late String refreshToken;
  @override
  void initState() {
    super.initState();
    getAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Liste'),
        backgroundColor: Colors.pink,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [const PopupMenuItem(value: 0, child: Text('Logout'))];
            },
            onSelected: (value) {
              if (value == 0) {
                logout();
              }
            },
          )
        ],
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: getAllTodos,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Slidable(
                    endActionPane:
                        ActionPane(motion: const StretchMotion(), children: [
                      if (!item['completed']) ...[
                        SlidableAction(
                          flex: 2,
                          onPressed: (context) async {
                            completeTodo(item);
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.check,
                          label: "Done",
                        ),
                      ],
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          Routing().navigateToEditTodo(item, '', context);
                        },
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: "Edit",
                      ),
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) {
                          deleteTodo(id);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: "Delete",
                      ),
                    ]),
                    child: ListTile(
                      leading: item['completed']
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.pink,
                            )
                          : const Icon(
                              Icons.crop_square,
                              color: Colors.grey,
                            ),
                      title: Text(
                        item['title'],
                        style: item['completed']
                            ? const TextStyle(
                                color: Colors.green,
                              )
                            : null,
                      ),
                      subtitle: Text(item['description']),
                      trailing: Text(formatDate(item['createAt'])),
                    ),
                  ),
                );
              }),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> navigateToAddTodo() async {
    Routing().navigateToAddTodo(context);
    setState(() {
      isLoading = true;
    });
  }

  Future<void> completeTodo(Map item) async {
    final id = item['_id'];
    const completed = true;
    final title = item['title'];
    final description = item['description'];

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
      getAllTodos();
      ShowMessages().showSuccess("Todo completed", context);
    } else {
      ShowMessages().showFailed("Todo nicht completed", context);
    }
  }

  Future<void> deleteTodo(String id) async {
    setState(() {
      isLoading = false;
    });
    final url = 'http://localhost:3000/api/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final newItems = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = newItems;
      });
      ShowMessages().showSuccess("Todo gelöscht", context);
    } else {
      ShowMessages().showFailed("Todo konnte nicht gelöscht werden", context);
    }
  }

  Future<void> getAllTodos() async {
    const url = 'http://localhost:3000/api/todos/getAllTodos';
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['todos'] as List;
      setState(() {
        items = result;
      });
      print(result);
    } else {
      ShowMessages().showFailed("Todo konnte nicht geladen werden", context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> logout() async {
    const url = 'http://localhost:3000/api/auth/logout';
    final uri = Uri.parse(url);

    final requestBody = {"refreshToken": widget.token};

    final response = await http.post(uri,
        body: jsonEncode(requestBody),
        headers: {'Content-type': 'application/json'});
    if (response.statusCode == 200) {
      Routing().navigateBackToLogin(context);
    } else {
      ShowMessages().showFailed("Logout fehlgeschlagen", context);
    }
  }

  String formatDate(String dateString) {
    final parsedDate = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(parsedDate);
  }
}
