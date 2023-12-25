import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/utils/todo_tile.dart';
import 'package:todoapp/utils/dialog_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // if this is the first time ever opening, create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there is already existing data
      db.loadData();
    }
    // TODO: implement initState
    super.initState();
  }

  // text controller
  final newTaskController = TextEditingController();

  // List toDoList = [
    // ["Make Tutorial", false],
    // ["Do Excercise", false],
  // ];

  // checkbox has changed
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
      // toDoList.delete();
    });

    db.updateData();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([newTaskController.text, false]);
      newTaskController.clear();
    });
    db.updateData();

    Navigator.of(context).pop();
  }

  // delete completed task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  // create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: newTaskController,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      appBar: AppBar(
        title: const Text('To Do List'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, idx) {
          return ToDoTile(
              taskName: db.toDoList[idx][0],
              taskCompleted: db.toDoList[idx][1],
              onChanged: (value) => checkBoxChanged(value, idx),
              deleteTask: (context) => deleteTask(idx),
          );
        },
      ),
    );
  }
}
