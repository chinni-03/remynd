import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/utils/filter_dialog_box.dart';
import 'package:todo_app/utils/new_task_dialog_box.dart';
import 'package:todo_app/utils/todo_tile.dart';

class CustomBottomBar extends StatelessWidget {
  final VoidCallback onCreateTask;
  final bool isDarkMode;
  final VoidCallback changeTheme;
  final VoidCallback filterTasks;

  const CustomBottomBar({
    super.key,
    required this.onCreateTask,
    required this.isDarkMode,
    required this.changeTheme,
    required this.filterTasks,
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
                    onPressed: filterTasks,
                    icon: FaIcon(
                      FontAwesomeIcons.sliders,
                      size: 24,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    highlightColor: Colors.transparent,
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
                    highlightColor: Colors.transparent,
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
  String filterType = "All";

  @override
  void initState() {
    // first time ever opening the app
    isDarkMode = _myBox.get('DARKMODE', defaultValue: false);
    filterType = "All tasks";
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
          isDarkMode: isDarkMode,
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

  void filterTasks() {
    showDialog(
      context: context,
      builder: (context) {
        return FilterDialogBox(
          onSelectFilter: (selectedFilter) {
            setState(() {
              filterType = selectedFilter;
            });
            Navigator.of(context).pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
          },
          isDarkMode: isDarkMode,
          currentFilter: filterType,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List filteredTasks =
        db.todoList.where((task) {
          if (filterType == "All tasks") return true;
          if (filterType == "Completed tasks") return task[1] == true;
          if (filterType == "Pending tasks") return task[1] == false;
          return true;
        }).toList();

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.grey[100],
      bottomNavigationBar: CustomBottomBar(
        onCreateTask: createNewTask,
        isDarkMode: isDarkMode,
        changeTheme: changeTheme,
        filterTasks: filterTasks,
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
              filteredTasks.isEmpty
                  ? Column(
                    children: [
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          filterType == "Pending tasks"
                              ? "Hooray! No tasks pending!"
                              : filterType == "Completed tasks"
                              ? "No tasks completed yet! Let's get to work now!"
                              : "No tasks added yet!",
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                isDarkMode ? Colors.white60 : Colors.grey[700],
                          ),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                  : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      int originalIndex = db.todoList.indexOf(
                        filteredTasks[index],
                      );
                      return TodoTile(
                        key: ValueKey(index),
                        taskName: filteredTasks[index][0],
                        taskCompleted: filteredTasks[index][1],
                        onChanged:
                            (value) => checkboxChanged(value, originalIndex),
                        deleteFunction: () => deleteTask(originalIndex),
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
