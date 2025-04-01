import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/utils/dialog_box.dart';
import 'package:todo_app/utils/todo_tile.dart';

class CustomBottomBar extends StatelessWidget {
  final VoidCallback onCreateTask;
  final bool isDarkMode;
  final VoidCallback changeTheme;

  const CustomBottomBar({
    super.key,
    required this.onCreateTask,
    required this.isDarkMode,
    required this.changeTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: BottomAppBar(
            height: MediaQuery.of(context).size.height * 0.1,
            shape: CircularNotchedRectangle(),
            color: Colors.grey.withOpacity(0.2),
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.sliders,
                      size: 24,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                  width: 180,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: onCreateTask,
                        color: isDarkMode ? Colors.black : Colors.white,
                        icon: Icon(CupertinoIcons.plus, size: 36),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: IconButton(
                    onPressed: changeTheme,
                    icon: FaIcon(
                      isDarkMode
                          ? FontAwesomeIcons.solidMoon
                          : FontAwesomeIcons.sun,
                      size: 24,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference box
  final _myBox = Hive.box('mybox');
  TodoDatabase db = TodoDatabase();
  bool isDarkMode = false;

  @override
  void initState() {
    // first time ever opening the app
    isDarkMode = _myBox.get('DARKMODE', defaultValue: false);
    if (_myBox.get("TODOLIST") == null) {
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
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        db.todoList.add([_controller.text.trim(), false]);
      });
      db.updateDataBase();
    }
    _controller.clear();
    Navigator.of(context).pop();
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

  void changeTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      _myBox.put('DARKMODE', isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.grey[100],
      bottomNavigationBar: CustomBottomBar(
        onCreateTask: createNewTask,
        isDarkMode: isDarkMode,
        changeTheme: changeTheme,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            right: 16.0,
            bottom: 0.0,
            left: 16.0,
          ),
          child:
              db.todoList.isEmpty
                  ? Column(
                    children: [
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          "No tasks added yet!",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
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
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
