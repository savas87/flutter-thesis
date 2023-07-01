import 'package:flutter/material.dart';
import 'package:taskify_app/models/items.dart';


class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

final TextEditingController _textEditingController = TextEditingController();

@override
void dispose() {
  _textEditingController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {

    final Items item = ModalRoute.of(context)!.settings.arguments as Items;
    _textEditingController.text = item.name;



    return Scaffold(
      appBar: AppBar(
        title: const Text("Update item"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
      
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  
                  ),
                  ),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = _textEditingController.text;
                if (newName.isNotEmpty) {
                  setState(() {
                    item.name = newName;
                  });
                }
                Navigator.pop(context);

              }, child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}