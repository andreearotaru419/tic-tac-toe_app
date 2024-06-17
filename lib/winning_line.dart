import 'package:flutter/material.dart';

class WinningLine extends StatelessWidget {
  final int start;
  final int step;
  final Color color;

  const WinningLine({
    super.key,
    required this.start,
    required this.step,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WinningLinePainter(start: start, step: step, color: color),
    );
  }
}

class _WinningLinePainter extends CustomPainter {
  final int start;
  final int step;
  final Color color;

  _WinningLinePainter({
    required this.start,
    required this.step,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = color
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    late Offset startOffset;
    late Offset endOffset;

    switch (step) {
      case 1:
        startOffset = Offset(0, start * size.height / 3 + size.height / 6);
        endOffset =
            Offset(size.width, start * size.height / 3 + size.height / 6);
        break;
      case 3:
        startOffset = Offset(start * size.width / 3 + size.width / 6, 0);
        endOffset =
            Offset(start * size.width / 3 + size.width / 6, size.height);
        break;
      case 4:
        startOffset = const Offset(0, 0);
        endOffset = Offset(size.width, size.height);
        break;
      case 2:
        startOffset = Offset(size.width, 0);
        endOffset = Offset(0, size.height);
        break;
      default:
        startOffset = Offset.zero;
        endOffset = Offset.zero;
        break;
    }

    canvas.drawLine(startOffset, endOffset, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
