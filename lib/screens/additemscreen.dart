import 'package:flutter/material.dart';
import 'package:taskify_app/models/items.dart';

import '../configuration.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {

final TextEditingController _textEditingController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {

    final taskList = context.dependOnInheritedWidgetOfExactType<Configuration>()!.taskList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("add item"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  
                  ),
                  ),
            ),
            ElevatedButton(
              onPressed: (){
                taskList.add(Items(name: _textEditingController.text, done: false));
                Navigator.pop(context);
              }, child: const Text("Hinzufügen")),
          ],
        ),
      ),
    );
  }
}