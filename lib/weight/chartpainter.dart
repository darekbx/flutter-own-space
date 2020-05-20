
import 'package:flutter/material.dart';
import 'package:ownspace/weight/model/entry.dart';

class ChartPainter extends CustomPainter {

  final List<Entry> entries;
  final double maxWeight;
  final double minWeight;

  final double padding = 16;
  final Paint paintType1 = Paint();
  final Paint paintType2 = Paint();
  final Paint paintType3 = Paint();
  final Paint paintLine = Paint();

  TextStyle textStyle;

  ChartPainter(this.entries, this.maxWeight, this.minWeight) {
    paintType1.color = Colors.pink;
    paintType2.color = Colors.lightBlue;
    paintType3.color = Colors.green;
    paintLine.color = Colors.black12;

    textStyle = new TextStyle(color: Colors.grey, fontSize: 10.0);
  }

  @override
  void paint(Canvas canvas, Size size) {

    drawEntries(canvas, size, entriesByType(1), paintType1);
    drawEntries(canvas, size, entriesByType(2), paintType2);
    drawEntries(canvas, size, entriesByType(3), paintType3);

    drawGuideLine(size, canvas, 10.0);
    drawGuideLine(size, canvas, 20.0);
    drawGuideLine(size, canvas, 30.0);
    drawGuideLine(size, canvas, 40.0);
    drawGuideLine(size, canvas, 50.0);
    drawGuideLine(size, canvas, 55.0);
    drawGuideLine(size, canvas, 60.0);
    drawGuideLine(size, canvas, 70.0);
  }

  void drawGuideLine(Size size, Canvas canvas, double weight) {
    double heightRatio = size.height / maxWeight;
    Offset p0 = Offset(padding, convertWeight(size, weight, heightRatio));
    Offset p1 = Offset(size.width, convertWeight(size, weight, heightRatio));
    canvas.drawLine(p0, p1, paintLine);

    var textSpan = new TextSpan(style: textStyle, text: "${weight.toInt()}");
    var textPainter = new TextPainter(
        text: textSpan, textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    textPainter.layout();

    textPainter.paint(canvas, new Offset(2, p0.dy - 6));
  }

  double convertWeight(Size size, double weight, double heightRatio) =>
      size.height / 1.2 - ((weight - minWeight) * heightRatio);

  void drawEntries(Canvas canvas, Size size, List<Entry> entries, Paint paint) {
    if (entries.isEmpty) {
      return;
    }

    double heightRatio = size.height / maxWeight;
    double widthStep = (size.width - padding) / entries.length;
    double start = padding;

    Offset p0 = Offset(start, convertWeight(size, entries[0].weight, heightRatio));

    entries.skip(1).forEach((entry) {
      Offset p1 = Offset(start + widthStep, convertWeight(size, entry.weight, heightRatio));
      canvas.drawLine(p0, p1, paint);
      p0 = p1;
      start += widthStep;
    });
  }

  Iterable<Entry> entriesByType(int type) => entries.where((entry) => entry.type == type).toList();

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}