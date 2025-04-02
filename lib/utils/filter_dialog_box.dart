import 'package:flutter/material.dart';

class FilterDialogBox extends StatefulWidget {
  final Function(String) onSelectFilter;
  final bool isDarkMode;
  final String currentFilter;

  const FilterDialogBox({
    super.key,
    required this.onSelectFilter,
    required this.isDarkMode,
    required this.currentFilter,
  });

  @override
  State<FilterDialogBox> createState() => _FilterDialogBoxState();
}

class _FilterDialogBoxState extends State<FilterDialogBox> {
  String selectedFilter = "All tasks";

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.currentFilter;
  }

  WidgetStateProperty<Color> getRadioFillColor() {
    return WidgetStateProperty.resolveWith<Color>((states) {
      if (widget.isDarkMode) {
        return Colors.white;
      } else {
        return Colors.grey[800]!;
      }
    });
  }

  void updateFilter(String value) {
    setState(() {
      selectedFilter = value;
    });
    widget.onSelectFilter(selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200]!,
      title: Text(
        "Filter Tasks",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: widget.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => updateFilter("All tasks"),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All tasks",
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Radio<String>(
                    value: "All tasks",
                    groupValue: selectedFilter,
                    onChanged: (value) => updateFilter(value!),
                    activeColor:
                        widget.isDarkMode ? Colors.white : Colors.grey[800],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    fillColor: getRadioFillColor(),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => updateFilter("Completed tasks"),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Completed tasks",
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Radio<String>(
                    value: "Completed tasks",
                    groupValue: selectedFilter,
                    onChanged: (value) => updateFilter(value!),
                    activeColor:
                        widget.isDarkMode ? Colors.white : Colors.grey[800],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    fillColor: getRadioFillColor(),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => updateFilter("Pending tasks"),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pending tasks",
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Radio<String>(
                    value: "Pending tasks",
                    groupValue: selectedFilter,
                    onChanged: (value) => updateFilter(value!),
                    activeColor:
                        widget.isDarkMode ? Colors.white : Colors.grey[800],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    fillColor: getRadioFillColor(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
