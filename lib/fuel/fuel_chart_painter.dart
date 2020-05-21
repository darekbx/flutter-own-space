
import 'package:flutter/material.dart';
import 'package:ownspace/fuel/model/fuel_entry.dart';

class FuelChartPainter extends CustomPainter {

  final List<FuelEntry> fuelEntries;

  final double ratio = 8;
  final double padding = 32;
  final Paint paintType = Paint();
  final Paint paintLine = Paint();

  TextStyle textStyle;
  int lastType = 0;

  FuelChartPainter(this.fuelEntries) {
    paintType.color = Colors.black;
    paintLine.color = Colors.black12;

    textStyle = new TextStyle(color: Colors.grey, fontSize: 10.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawEntries(canvas, size);
    drawGuideLine(canvas, size, fuelEntries.last.pricePerLiter());
  }

  void drawGuideLine(Canvas canvas, Size size, double price) {
    double heightRatio = size.height / ratio;
    Offset p0 = Offset(padding, convertPrice(size, price, heightRatio));
    Offset p1 = Offset(size.width, convertPrice(size, price, heightRatio));
    canvas.drawLine(p0, p1, paintLine);

    var textSpan = new TextSpan(style: textStyle, text: "${price.toStringAsFixed(2)}zł");
    var textPainter = new TextPainter(
        text: textSpan, textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    textPainter.layout();

    textPainter.paint(canvas, new Offset(2, p0.dy - 6));
  }

  double convertPrice(Size size, double price, double heightRatio) =>
      size.height - (price * heightRatio);

  void drawEntries(Canvas canvas, Size size) {
    if (fuelEntries.isEmpty) {
      return;
    }

    double heightRatio = size.height / ratio;
    double widthStep = (size.width - padding) / fuelEntries.length;
    double start = padding;

    Offset p0 = Offset(start, convertPrice(size, fuelEntries[0].pricePerLiter(), heightRatio));

    fuelEntries.skip(1).forEach((entry) {
      Offset p1 = Offset(start + widthStep, convertPrice(size, entry.pricePerLiter(), heightRatio));

      if (entry.type != lastType) {
        paintType.color = entry.type == 0 ? Colors.black : Colors.green;
      }

      lastType = entry.type;

      canvas.drawLine(p0, p1, paintType);
      p0 = p1;
      start += widthStep;
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}