import 'package:flutter/material.dart';
import 'package:taskify_app/configuration.dart';
import 'package:taskify_app/screens/additemscreen.dart';
import 'package:taskify_app/screens/todoitems.dart';
import 'package:taskify_app/screens/updateitemscreen.dart';

import 'models/items.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Configuration(

      taskList: [
        Items(name: "Idioten", done: false),
        Items(name: "Zwiebel", done: false),
        Items(name: "Getränke", done: false),
        Items(name: "Stifte", done: false),],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const todoitems(),
          "/Hinzufügen": (context) => const AddItemScreen(),
          "/Update":(context) => const UpdateScreen(),
        },
      ),
    );
  }
}

