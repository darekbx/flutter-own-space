import 'package:flutter/material.dart';
import 'dart:math';
import 'color_tool.dart';

class Chart extends CustomPainter {
  final List<double> values;
  final double padding = 10.0;
  var _chartPaint = Paint();
  var _colorPaint = Paint();

  Chart(this.values) {
    _colorPaint.style = PaintingStyle.fill;
    _colorPaint.color = Colors.blueGrey;

    _chartPaint.style = PaintingStyle.stroke;
    _chartPaint.strokeWidth = 1.2;
  }

  void _drawChart(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    var gradient = LinearGradient(colors: List());
    var tempX = -1.0;
    var tempY = 0.0;
    var tempColor = Colors.white;
    var stepX = size.width.toDouble() / (values.length.toDouble() - 1);
    var ratioY = (size.height.toDouble() - padding) / _maxValue();
    values.forEach((value) {
      if (tempX == -1) {
        tempX = 0.0;
        tempY = value;
        tempColor = ColorTool.colorByAmount(value);
      } else {
        
        gradient.colors.clear();
        gradient.colors.add(tempColor);
        gradient.colors.add(ColorTool.colorByAmount(value));

        var p1 = Offset(tempX, size.height - tempY);
        tempX += stepX;
        tempY = value * ratioY;
        var p2 = Offset(tempX, size.height - tempY);

        _chartPaint.shader = gradient.createShader(Rect.fromPoints(p1, p2));
        canvas.drawLine(p1, p2, _chartPaint);

        tempColor = ColorTool.colorByAmount(value);
      }
    });
  }

  double _maxValue() => values.reduce(max);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _colorPaint);
    _drawChart(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
