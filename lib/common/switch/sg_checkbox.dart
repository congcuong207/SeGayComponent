// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class SgCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? text;
  final Color? checkedColor;
  final Color? uncheckedColor;
  final Color? checkmarkColor;
  final Color? borderCheckedColor;
  final Color? borderUncheckedColor;
  final TextStyle? textStyle;
  final double size;
  final double borderRadius;
  final Duration animationDuration;

  const SgCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.text,
    this.checkedColor,
    this.uncheckedColor,
    this.checkmarkColor,
    this.borderCheckedColor,
    this.borderUncheckedColor,
    this.textStyle,
    this.size = 20.0,
    this.borderRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<SgCheckbox> createState() => _SgCheckboxState();
}

class _SgCheckboxState extends State<SgCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.value) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SgCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Checkbox
        GestureDetector(
          onTap: () {
            widget.onChanged?.call(!widget.value);
          },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: _getBackgroundColor(),
                  border: Border.all(
                    color: _getBorderColor(),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _animation.value,
                    duration: widget.animationDuration,
                    child: Icon(
                      Icons.check,
                      size: widget.size * 0.6,
                      color: widget.checkmarkColor ?? Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Text
        if (widget.text != null) ...[
          const SizedBox(width: 8),
          Text(
            widget.text!,
            style: widget.textStyle ?? const TextStyle(
              fontSize: 14,
              color: SGAppColors.dark,
            ),
          ),
        ],
      ],
    );
  }

  Color _getBackgroundColor() {
    if (widget.value) {
      return widget.checkedColor ?? const Color(0xFF2196F3); // Blue color
    } else {
      return widget.uncheckedColor ?? Colors.transparent;
    }
  }

  Color _getBorderColor() {
    if (widget.value) {
      return widget.borderCheckedColor ?? const Color(0xFF2196F3);
    } else {
      return widget.borderUncheckedColor ?? Colors.grey;
    }
  }
} 