import 'package:flutter/material.dart';

class SidebarOverlay extends StatelessWidget {
  final bool show;
  final VoidCallback onClose;
  final Widget sidebar;
  const SidebarOverlay({
    super.key,
    required this.show,
    required this.onClose,
    required this.sidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: AnimatedOpacity(
            opacity: show ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !show,
              child: Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        ),
        AnimatedSlide(
          offset: show ? const Offset(0, 0) : const Offset(-1, 0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          child: SizedBox(
            width: 250,
            child: sidebar,
          ),
        ),
      ],
    );
  }
}
