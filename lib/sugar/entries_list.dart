import 'package:flutter/material.dart';
import 'package:ownspace/sugar/model/entry.dart';
import 'color_tool.dart';

class EntryList extends StatelessWidget {
  final Map<String, List<Entry>> entries;

  EntryList(this.entries);

  @override
  Widget build(BuildContext context) {
    var keys = entries.keys.toList();
    var values = entries.values.toList();
    return ListView.builder(
      padding: EdgeInsets.all(0.0),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(   
            title: _createTitleEntry(keys[index], values[index]),
            children: _createSubEntry(values[index]));
      },
    );
  }

  Widget _createTitleEntry(String date, List<Entry> entries) {
    num sum = 0.0;
    entries.forEach((entry) => sum += entry.sugar);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("$date (${entries.length})"),
        Text(
          "${sum.toStringAsFixed(1)}", 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: ColorTool.colorByAmount(sum))
        )
      ],
    );
  }

  List<Widget> _createSubEntry(List<Entry> entries) {
    return entries.reversed.map((entry) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 54.0, 4.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 8.0, 0), child: Text(entry.name)), 
                SizedBox(
                  child: Text("${entry.sugar}", style: TextStyle(fontWeight: FontWeight.bold)),
                  width: 30.0,
                )
              ]));
    }).toList();
  }
}
