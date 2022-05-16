
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/year_summary.dart';

class StatisticsChartPainter extends CustomPainter {

  final List<YearSummary> entries;

  final double heightRatio = 1.5;
  final double padding = 16;
  final Paint paintType = Paint();
  final Paint paintTypePolish = Paint();
  final Paint paintTypeEnglish = Paint();
  final Paint paintLine = Paint();

  TextStyle textStyle;
  int lastType = 0;

  StatisticsChartPainter(this.entries) {
    paintTypePolish.color = Color.fromARGB(255, 182, 24, 39);
    paintTypeEnglish.color = Color.fromARGB(255, 0, 92, 178);
    paintType.color = Colors.black;
    paintType.strokeWidth = 1.0;
    paintLine.color = Colors.black;

    textStyle = new TextStyle(color: Colors.grey, fontSize: 10.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawEntries(canvas, size);
  }

  double convertY(Size size, int value) =>
      (size.height - padding / 2) - (value);

  double degreeToRadian(double degree) {
    return degree * 3.141 / 180;
  }

  void drawEntries(Canvas canvas, Size size) {
    if (entries.isEmpty) {
      return;
    }

    canvas.drawColor(Color.fromARGB(5, 0, 0, 0), BlendMode.srcOver);
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), paintLine);

    double widthStep = (size.width - padding * 2) / (entries.length);
    double start = padding / 2;

    entries.forEach((entry) {
      canvas.drawRect(Rect.fromLTRB(
          start, (entry.polishCount() + entry.englishCount) * heightRatio,
          start + widthStep, 0), paintTypeEnglish);
      canvas.drawRect(Rect.fromLTRB(
          start, entry.polishCount() * heightRatio, start + widthStep, 0),
          paintTypePolish);
      start += widthStep + 1;
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
