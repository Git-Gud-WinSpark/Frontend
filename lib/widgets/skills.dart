import 'package:flutter/material.dart';

class ToggleSkills extends StatefulWidget {
  const ToggleSkills({
    super.key,
    required this.text,
    required this.onToggle,
  });

  final String text;
  final void Function(String, bool) onToggle;

  @override
  State<ToggleSkills> createState() => _ToggleSkillsState();
}

class _ToggleSkillsState extends State<ToggleSkills> {
  bool isSelected = false;

  void _handlePress() {
    setState(() {
      isSelected = !isSelected;
    });
    widget.onToggle(widget.text, isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onToggle(widget.text, isSelected);
        _handlePress();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.inversePrimary),
      child: Text(widget.text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
    );
  }
}
