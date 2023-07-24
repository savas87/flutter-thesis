import 'package:flutter/material.dart';
import '../screens/add_todo.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/todo_list.dart';

class Routing {
  void navigateBackToLogin(BuildContext context) {
    final route = MaterialPageRoute(
      builder: (context) => const LoginPage(),
    );
    Navigator.push(context, route);
  }

  void navigateToTodoList(String refreshToken, BuildContext context) {
    final route = MaterialPageRoute(
      builder: (context) => TodoList(token: refreshToken),
    );
    Navigator.push(context, route);
  }

  void navigateToRegisterPage(BuildContext context) {
    final route = MaterialPageRoute(builder: (context) => const RegisterPage());
    Navigator.push(context, route);
  }

  void navigateToAddTodo(BuildContext context) {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoItem(),
    );
    Navigator.push(context, route);
  }

  void navigateToEditTodo(Map item, String token, BuildContext context) {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoItem(todo: item),
    );
    Navigator.push(context, route);
  }
}
