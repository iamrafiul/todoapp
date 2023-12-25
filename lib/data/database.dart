import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  // reference the box
  final _myBox = Hive.box('mybox');

  // create initial data first time ever opening the app
  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false],
      ["Do Excercise", false],
    ];
  }

  // load data from database
  void loadData() {
      toDoList = _myBox.get("TODOLIST");
  }

  // update/insert data in database
  void updateData() {
    _myBox.put("TODOLIST", toDoList);
  }
}