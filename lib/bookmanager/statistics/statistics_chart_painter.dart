
import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/model/year_summary.dart';

class StatisticsChartPainter extends CustomPainter {

  final List<YearSummary> entries;

  final double padding = 16;
  final Paint paintType = Paint();
  final Paint paintTypeEnglish = Paint();
  final Paint paintLine = Paint();

  TextStyle textStyle;
  int lastType = 0;

  StatisticsChartPainter(this.entries) {
    paintType.color = Colors.black;
    paintTypeEnglish.color = Colors.blue;
    paintLine.color = Colors.black;

    textStyle = new TextStyle(color: Colors.grey, fontSize: 10.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawEntries(canvas, size);
  }

  double convertY(Size size, int value) =>
      (size.height - padding / 2) - (value);

  void drawEntries(Canvas canvas, Size size) {
    if (entries.isEmpty) {
      return;
    }

    canvas.drawColor(Color.fromARGB(5, 0, 0, 0), BlendMode.srcOver);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paintLine);

    double widthStep = (size.width ) / (entries.length - 0) ;
    double start = padding;

    Offset p0 = Offset(start, convertY(size, entries[0].count));
    Offset p0e = Offset(start, convertY(size, entries[0].englishCount));

    entries.skip(1).forEach((entry) {
      Offset p1 = Offset(start + widthStep, convertY(size, entry.count));
      canvas.drawLine(p0, p1, paintType);
      Offset p1e = Offset(start + widthStep, convertY(size, entry.englishCount));
      canvas.drawLine(p0e, p1e, paintTypeEnglish);
      p0 = p1;
      p0e = p1e;
      start += widthStep;
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}