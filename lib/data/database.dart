import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  List todoList = [];

  final _myBox = Hive.box('mybox');

  // first time ever opening the app
  void createInitialData() {
    todoList = [];
  }

  // load the data
  void loadData() {
    todoList = _myBox.get('TODOLIST');
  }

  // updations
  void updateDataBase() {
    _myBox.put("TODOLIST", todoList);
  }
}
