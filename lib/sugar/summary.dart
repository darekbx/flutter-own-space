import 'package:flutter/material.dart';
import 'package:ownspace/sugar/model/entry.dart';
import 'color_tool.dart';
import 'date_utils.dart';
import 'settings_page.dart';

class Summary extends StatelessWidget {
  final List<Entry> entries;

  Summary(this.entries);

  int _itemsCount() => entries.length;

  String _sugarEatenFormatted() {
    double sum = 0.0;
    entries.forEach((entry) {
      sum += entry.sugar;
    });
    sum /= 1000;
    return sum.toStringAsFixed(3);
  }

  double _todaysSugar() {
    var date = DateTime.now();
    var nowString = DateUtils.formatDate(date);

    double sum = 0.0;
    entries.forEach((entry) {
      if (entry.dateTime() == nowString) {
        sum += entry.sugar;
      }
    });

    return sum;
  }

  String _todaysSugarFormatted() {
    double sum = _todaysSugar();
    return sum.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) => Container(
      color: Colors.green,
      child: Row(children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    defaultText('Today\'s sugar: ', 28),
                    defaultText("${_todaysSugarFormatted()}g", 28,
                        ColorTool.colorByAmount(_todaysSugar()))
                  ]),
                  defaultText('Item\'s count: ${_itemsCount()}', 18),
                  defaultText('Sugar eaten: ${_sugarEatenFormatted()}kg', 18),
                ])),
        Spacer(flex: 2),
        Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ))
      ]));

  Widget defaultText(String text, double size, [Color color = Colors.white]) =>
      Text(
        text,
        style: TextStyle(color: color, fontSize: size, height: 1.1),
        textAlign: TextAlign.left,
      );
}
