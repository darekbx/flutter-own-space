import 'package:flutter/material.dart';
import 'package:ownspace/news/repository/localstorage.dart';

class Settings extends StatefulWidget {
  Settings();

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _apiInputController = TextEditingController();
  var _apiSecretInputController = TextEditingController();
  var _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _loadKey();
    _apiInputController.addListener(() {
      _localStorage.setApiKeyAndSecret(
          _apiInputController.text,
          _apiSecretInputController.text
      );
    });
    _apiSecretInputController.addListener(() {
      _localStorage.setApiKeyAndSecret(
          _apiInputController.text,
          _apiSecretInputController.text
      );
    });
  }

  @override
  void dispose() {
    _apiInputController.dispose();
    _apiSecretInputController.dispose();
    super.dispose();
  }

  void _loadKey() async {
    var apiKey = await _localStorage.getApiKey();
    var apiSecret = await _localStorage.getApiSecret();
    setState(() {
      _apiInputController.text = apiKey;
      _apiSecretInputController.text = apiSecret;
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
                ),
                Text("Enter your private API secret"),
                TextField(
                  controller: _apiSecretInputController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "API secret"),
                )
              ],
            )));
  }
}
