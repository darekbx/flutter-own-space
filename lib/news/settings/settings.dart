import 'package:flutter/material.dart';
import 'package:ownspace/news/repository/localstorage.dart';

class Settings extends StatefulWidget {
  Settings();

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _apiInputController = TextEditingController();
  var _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _loadKey();
    _apiInputController.addListener(() {
      _localStorage.setApiKey(_apiInputController.text);
    });
  }

  @override
  void dispose() {
    _apiInputController.dispose();
    super.dispose();
  }

  void _loadKey() async {
    var apiKey = await _localStorage.getApiKey();
    setState(() {
      _apiInputController.text = apiKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Enter your private API key"),
                TextField(
                  controller: _apiInputController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "API key"),
                )
              ],
            )));
  }
}
