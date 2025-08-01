import 'package:flutter/material.dart';

class SgIndicator extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTap;
  final EdgeInsets? paddingItem;
  final double? fontSize;

  const SgIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
    this.paddingItem,
    this.onStepTap,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isFirst = index == 0;
        final isLast = index == steps.length - 1;
        return GestureDetector(
          onTap: onStepTap != null ? () => onStepTap!(index) : null,
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 3),
                child: CustomPaint(
                  painter: _StepPainter(
                    isActive: isActive,
                    isFirst: isFirst,
                    isLast: isLast,
                  ),
                  child: Container(
                    padding:
                        paddingItem ??
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    alignment: Alignment.center,
                    child: Text(
                      steps[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.black : Colors.grey,
                        fontSize: fontSize ?? 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StepPainter extends CustomPainter {
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  _StepPainter({
    required this.isActive,
    required this.isFirst,
    required this.isLast,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double arrowWidth = 12;
    final paint =
        Paint()
          ..color =
              isActive
                  ? const Color(0xFFEAF7F8)
                  : const Color.fromARGB(15, 52, 52, 52)
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = isActive ? const Color(0xFF0097A7) : Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final path = Path();

    if (isFirst) {
      // Mũi tên phải
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width + arrowWidth, size.height / 2);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    } else if (isLast) {
      // Mũi tên trái vuông
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(arrowWidth, size.height / 2);

      path.close();
    } else {
      // Mũi tên hai đầu
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width + arrowWidth, size.height / 2);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(arrowWidth, size.height / 2);
      path.close();
    }
    canvas.drawPath(path, borderPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
