import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const Button({
    super.key,
    required this.buttonName,
    required this.onPressed,
    required this.isDarkMode,
  });

  Color getButtonColor(String buttonName) {
    switch (buttonName.toLowerCase()) {
      case "add task":
        return isDarkMode ? Colors.white : Colors.grey[850]!;
      case "cancel":
        return Colors.transparent;
      default:
        return Colors.transparent;
    }
  }

  Color getTextColor(String buttonName) {
    switch (buttonName.toLowerCase()) {
      case "add task":
        return isDarkMode ? Colors.black : Colors.white;
      case "cancel":
        return isDarkMode ? Colors.white : Colors.black;
      default:
        return isDarkMode ? Colors.white : Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getButtonColor(buttonName),
        border: Border.all(
          color: isDarkMode ? Colors.white : Colors.grey[850]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        onPressed: onPressed,
        textColor: getTextColor(buttonName),
        child: Text(buttonName),
      ),
    );
  }
}
