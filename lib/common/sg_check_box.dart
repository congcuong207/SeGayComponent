import 'package:flutter/material.dart';

class SGCheckBox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color checkColor;
  final double size;

  const SGCheckBox({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.checkColor = Colors.white,
    this.size = 24.0,
  });

  @override
  State<SGCheckBox> createState() => _SGCheckBoxState();
}

class _SGCheckBoxState extends State<SGCheckBox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  void _toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
    widget.onChanged(isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: isChecked ? widget.activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: widget.activeColor,
            width: 2,
          ),
        ),
        child: isChecked
            ? Icon(
                Icons.check,
                color: widget.checkColor,
                size: widget.size * 0.6,
              )
            : null,
      ),
    );
  }
}