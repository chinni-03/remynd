import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/utils/dialog_box.dart';
import 'package:todo_app/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // reference box
  final _myBox = Hive.box('mybox');
  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    // first time ever opening the app
    if(_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  final _controller = TextEditingController();

  void checkboxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
    });
    _controller.clear();
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () {
            _controller.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('TO DO'),
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * 0.075,
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: createNewTask,
        elevation: 0,
        backgroundColor: Colors.grey[700],
        child: Icon(CupertinoIcons.plus, size: 28, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child:
            db.todoList.isEmpty
                ? Column(
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        "No tasks added yet!",
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  itemCount: db.todoList.length,
                  itemBuilder: (context, index) {
                    return TodoTile(
                      key: ValueKey(index),
                      taskName: db.todoList[index][0],
                      taskCompleted: db.todoList[index][1],
                      onChanged: (value) => checkboxChanged(value, index),
                      deleteFunction: () => deleteTask(index),
                    );
                  },
                ),
      ),
    );
  }
}
