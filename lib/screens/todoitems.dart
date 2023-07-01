import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskify_app/configuration.dart';

import '../models/items.dart';






class todoitems extends StatefulWidget {

  const todoitems({Key? key});

  @override
  State<todoitems> createState() => _todoitemsState();
}



class _todoitemsState extends State<todoitems> {

  void _showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(text),
      ),);
  }

  void updateTask(Items item, String newName) { setState(() {
      item.name = newName;
    });
  }
  @override
  Widget build(BuildContext context) {

    final taskList = context.dependOnInheritedWidgetOfExactType<Configuration>()!.taskList;

    return Scaffold(appBar: AppBar(title: const Text("To Do Liste"),
    backgroundColor: Colors.pink,
    ),
    body: Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index){
    
    final item = taskList[index];
    bool isChecked = item.done;
    
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
             children: [
              SlidableAction(
                flex: 2,
                onPressed: (context) async {
                  final newName = await 
                  Navigator.pushNamed(context, "/Update", arguments: item,);
                    if (newName != null) {
                      updateTask(item, newName as String);
                    }
                },
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: "Bearbeiten",
                
                ),
                SlidableAction(
                  onPressed: (context) {
                    setState(() {
                      taskList.removeAt(index);
                    });
                    _showSnackbar(context, "${item.name} deleted.");
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: "Löschen",
                  ),
             ], ),
            child: CheckboxListTile(
                title: Text(
                  item.name, 
                  style: isChecked ? const TextStyle(
                  decoration: TextDecoration.lineThrough,
                ) : null ,),
                value: isChecked, onChanged: (newValue){
                  setState(() {
                    isChecked = newValue!;
                    item.setDone(isChecked);
                  });
              }),
          ),
        );
      }),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed:() {
        Navigator.pushNamed(context, "/Hinzufügen").then((value) => setState((){}));
      },
      child: const Icon(Icons.add),
       ),
    );
  }
}