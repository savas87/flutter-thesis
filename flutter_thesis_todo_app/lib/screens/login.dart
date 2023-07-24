// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_thesis_todo_app/services/routingService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/messageService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String refreshToken = '';
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Image.asset('assets/logo.png'),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextField(
              controller: usernameController,
              style: const TextStyle(color: Colors.pink),
              decoration: InputDecoration(
                hintText: 'Benutzername',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.pink),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Bitte Passwort Eingeben',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0)),
              ),
            ),
          ),
          Container(
              height: 80,
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 500,
                child: ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                  ),
                  child: const Text('Einloggen'),
                ),
              )),
          TextButton(
            onPressed: () => Routing().navigateToRegisterPage(context),
            style: TextButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Register'),
          )
        ],
      ),
    ));
  }

  void initSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> submit() async {
    // get data
    final username = usernameController.text;
    final password = passwordController.text;

    final requestBody = {
      "username": username,
      "password": password,
    };

    // send todo
    const url = "http://localhost:3000/api/auth/login";
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );
    var jsonRes = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ShowMessages().showSuccess("Login erfolgreich", context);
      var refreshTokenRes = jsonRes['refreshToken'];
      prefs.setString('refreshToken', refreshTokenRes);
      waitRouting(refreshToken, context);
    } else {
      ShowMessages()
          .showFailed("Login Fehlgeschlagen: ${response.statusCode}", context);
    }
  }

  Future<void> waitRouting(String refreshToken, BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    Routing().navigateToTodoList(refreshToken, context);
  }
}
