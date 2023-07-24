// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/messageService.dart';
import '../services/routingService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
            child: Text(
              'Register',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .merge(const TextStyle(color: Colors.pink)),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: const Text('Bitte Benutzername und Passwort eingeben.'),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextField(
              controller: usernameController,
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
              decoration: InputDecoration(
                hintText: 'Passwort',
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
                  child: const Text('Register'),
                ),
              )),
          TextButton(
            onPressed: () => Routing().navigateBackToLogin(context),
            style: TextButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Zurück'),
          )
        ],
      ),
    ));
  }

  Future<void> submit() async {
    final username = usernameController.text;
    final password = passwordController.text;

    final requestBody = {
      "username": username,
      "password": password,
    };

    const url = "http://localhost:3000/api/auth/signup";
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      ShowMessages().showSuccess("Registrierung erfolgreich", context);
      waitRouting();
    } else {
      ShowMessages().showFailed(
          "Register Fehlgeschlagen: ${response.statusCode}", context);
    }
  }

  Future<void> waitRouting() async {
    await Future.delayed(const Duration(seconds: 2));
    Routing().navigateBackToLogin(context);
  }
}
