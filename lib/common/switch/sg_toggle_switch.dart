// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class SgToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? text;
  final Color? switchColor;
  final Color? trackColor;
  final Color? knobColor;
  final String? onIcon;
  final String? offIcon;
  final TextStyle? textStyle;
  final double width;
  final double height;
  final double? borderRadius;
  final Duration animationDuration;

  const SgToggleSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.text,
    this.switchColor,
    this.trackColor,
    this.knobColor,
    this.onIcon,
    this.offIcon,
    this.textStyle,
    this.width = 60.0,
    this.height = 30.0,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<SgToggleSwitch> createState() => _SgToggleSwitchState();
}

class _SgToggleSwitchState extends State<SgToggleSwitch>
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

    if (!widget.value) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SgToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (!widget.value) {
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
        // Toggle Switch
        GestureDetector(
          onTap: () {
            print("widget.value: ${widget.value}");
            widget.onChanged?.call(!widget.value);
            print(widget.value);
          },
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? widget.height / 2),
                  color: _getTrackColor(),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Knob
                    Positioned(
                      left:
                          _animation.value * (widget.width - widget.height + 3),
                      top: 2,
                      child: Container(
                        width: widget.height - 4,
                        height: widget.height - 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.knobColor ?? Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: widget.onIcon != null || widget.offIcon != null
                            ? Center(
                                child: Text(
                                  widget.value ? (widget.onIcon ?? '1') : (widget.offIcon ?? '0'),
                                  style: TextStyle(
                                    color: widget.value ? SGAppColors.dark : SGAppColors.dark,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                   
                  ],
                ),
              );
            },
          ),
        ),
        // Text
        if (widget.text != null) ...[
          const SizedBox(width: 12),
          Text(
            widget.text!,
            style: widget.textStyle ?? const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ],
    );
  }

  Color _getTrackColor() {
    if (widget.trackColor != null) {
      return widget.trackColor!;
    }
    
    if (!widget.value) {
      return widget.switchColor ?? const Color(0xFF4CAF50);
    } else {
      return Colors.grey[300] ?? Colors.grey;
    }
  }
}
