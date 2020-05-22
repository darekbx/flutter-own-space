import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:ownspace/sugar/model/entry.dart';
import 'package:ownspace/sugar/repository/repository.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Import data option, will add all sugar entries from old Sugar app.",
                      style: TextStyle(fontSize: 18, height: 1.1),
                    )),
                RaisedButton(
                    child: Text("Import data"),
                    onPressed: () {
                      confirmImport(context);
                    })
              ],
            )));
  }

  void confirmImport(BuildContext context) {
    var dialog = AlertDialog(
      title: Center(child: Text("Warning!")),
      content: Text("Data will not be overrided, will be added."),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Import"),
          onPressed: () async {
            await _import();
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  Future<void> _import() async {
    var jsonString = await DefaultAssetBundle.of(context)
        .loadString("assets/sugar_export.json");
    List<dynamic> json = jsonDecode(jsonString);
    
    json.forEach((row) async {
      var description = row["description"];
      var amount = row["amount"];
      var date = row["date"];
      await repository.add(Entry(null, description, amount, date));
    });
  }
}
