import 'package:flutter/material.dart';
import 'package:taskify_app/models/items.dart';


class Configuration extends InheritedWidget{

final List<Items> taskList;

const Configuration({super.key, 
  required this.taskList,
  required Widget child,
}) : super(child: child);

  @override
  bool updateShouldNotify(Configuration oldWidget) {
    return taskList != oldWidget.taskList;
    
  }

}