import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final VoidCallback deleteFunction;
  final bool isDarkMode;

  const TodoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Slidable(
        key: key,
        endActionPane: ActionPane(
          motion: StretchMotion(),
          dismissible: DismissiblePane(
            onDismissed: deleteFunction,
            closeOnCancel: false,
            dismissThreshold: 0.25,
          ),
          children: [
            CustomSlidableAction(
              onPressed: null,
              backgroundColor: isDarkMode ? Colors.white : Colors.black,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
              child: SizedBox(
                child: Icon(
                  CupertinoIcons.delete,
                  size: 24,
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900]! : Colors.grey[200]!,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  taskName,
                  style: TextStyle(
                    decoration:
                        taskCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  softWrap: true,
                ),
              ),
              Transform.scale(
                scale: 1.5,
                child: Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  child: Checkbox(
                    value: taskCompleted,
                    onChanged: onChanged,
                    checkColor: isDarkMode ? Colors.black : Colors.white,
                    activeColor: isDarkMode ? Colors.white : Colors.black,
                    side: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
