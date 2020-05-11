
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NotePainter extends CustomPainter {

  final double lineHeight = 17.0;
  final int lines = 100;
  final int padding = 8;
  double scrollPosition;

  final paintDarkgrey = Paint()
    ..color = Colors.black12
    ..strokeWidth = 0.5;

  NotePainter(this.scrollPosition);

  @override
  void paint(Canvas canvas, Size size) {
    var topPosition = padding - (scrollPosition);
    for (var rowIndex = 0; rowIndex < lines; rowIndex += 1) {
      var position = topPosition + lineHeight * rowIndex;
      // Overflow check
      if (position > padding && position < size.height - padding) {
        canvas.drawLine(
            Offset(0, position),
            Offset(size.width, position),
            paintDarkgrey);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}