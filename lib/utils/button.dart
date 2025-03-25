import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  const Button({super.key, required this.buttonName, required this.onPressed});

  Color getButtonColor(String buttonName) {
    switch (buttonName.toLowerCase()) {
      case "add task":
        return Colors.grey[850]!;
      case "cancel":
        return Colors.transparent;
      default:
        return Colors.transparent;
    }
  }

  Color getTextColor(String buttonName) {
    switch (buttonName.toLowerCase()) {
      case "add task":
        return Colors.white;
      case "cancel":
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getButtonColor(buttonName),
        border: Border.all(color: Colors.grey[850]!, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        textColor: getTextColor(buttonName),
        child: Text(buttonName),
      ),
    );
  }
}
