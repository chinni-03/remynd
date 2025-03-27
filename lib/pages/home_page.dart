import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/utils/dialog_box.dart';
import 'package:todo_app/utils/todo_tile.dart';

class CustomBottomBar extends StatelessWidget {
  final VoidCallback onCreateTask;

  const CustomBottomBar({super.key, required this.onCreateTask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.sliders, size: 24),
                ),
              ),
              GestureDetector(
                onTap: onCreateTask,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Icon(Icons.add_rounded, color: Colors.white, size: 40),
                  ),
                ),
              ),
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.ellipsisVertical, size: 24),
                ),
              ),
            ],
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

  @override
  void initState() {
    // first time ever opening the app
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
      bottomNavigationBar: CustomBottomBar(onCreateTask: createNewTask),
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
