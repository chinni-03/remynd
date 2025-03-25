import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final VoidCallback deleteFunction;

  const TodoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            SlidableAction(
              onPressed: null,
              icon: CupertinoIcons.delete_solid,
              backgroundColor: Colors.red[400]!,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                taskName,
                style: TextStyle(
                  decoration:
                      taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                ),
              ),
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                checkColor: Colors.grey[600],
                fillColor: WidgetStateColor.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
