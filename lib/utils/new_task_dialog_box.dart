import 'package:flutter/material.dart';
import 'package:todo_app/utils/button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isDarkMode;

  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              cursorColor: isDarkMode ? Colors.white70 : Colors.grey,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.grey[800]),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white70 : Colors.grey,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white70 : Colors.grey,
                  ),
                ),
                hintText: 'Add a new task',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  buttonName: "Cancel",
                  onPressed: onCancel,
                  isDarkMode: isDarkMode,
                ),
                Button(
                  buttonName: "Add Task",
                  onPressed: onSave,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
