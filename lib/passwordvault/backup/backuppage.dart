import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:ownspace/passwordvault/security/encryptedstorage.dart';
import 'package:ownspace/passwordvault/storage.dart';

class BackupPage extends StatefulWidget {
  BackupPage({Key key}) : super(key: key);

  @override
  _BackupState createState() => _BackupState();
}

class _BackupState extends State<BackupPage> {
  final Storage _storage = Storage();
  final _textFieldController = TextEditingController();
  var _statusText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Vault"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextField(),
          _buildStatusText(),
          Expanded(child: Container()),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            _buildButton("Import", () => import()),
            _buildButton("Export", () => export())
          ]),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
        padding: EdgeInsets.all(16),
        child: TextFormField(
          controller: _textFieldController,
          textAlign: TextAlign.start,
          maxLines: 26,
          style: TextStyle(fontFamily: 'RobotoMono'),
          decoration:
              InputDecoration(hintText: "", border: OutlineInputBorder()),
        ));
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
            child: RaisedButton(
                child: Text(text),
                textColor: Colors.white,
                color: Colors.blueGrey,
                onPressed: () => onPressed())));
  }

  Widget _buildStatusText() {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
        child: Text(_statusText));
  }

  Future<String> loadDecryptionSample() async {
    return await rootBundle.loadString('assets/decryption_sample.base64');
  }

  void export() async {
    try {
      var pin = await _storage.readPin();
      var encryptedStorage = EncryptedStorage(pin);
      var data = await encryptedStorage.export();
      data["PythonDecryptionSample"] = await loadDecryptionSample();
      var dataJson = json.encode(data);
      _textFieldController.text = dataJson;
      setState(() {
        _statusText = "Data exported";
      });
    } catch (e) {
      setState(() {
        _statusText = "Export error: $e";
      });
    }
  }

  Future import() async {
    var dataJson = _textFieldController.text;
    if (dataJson.isNotEmpty) {
      try {
        var data = json.decode(dataJson);
        var pin = await _storage.readPin();
        var encryptedStorage = EncryptedStorage(pin);
        await encryptedStorage.import(data);
        setState(() {
          _statusText = "Data was imported";
        });
      } catch (e) {
        setState(() {
          _statusText = "Import error: $e";
        });
      }
    } else {
      setState(() {
        _statusText = "Text field is empty";
      });
    }
  }
}
