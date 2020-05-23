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
      //resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Password Vault"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextField(),
          _buildStatusText(),
          _buildButton("Import", () => import())
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Expanded(child: Container(
        padding: EdgeInsets.all(16),
        child: TextFormField(
          controller: _textFieldController,
          textAlign: TextAlign.start,
          style: TextStyle(fontFamily: 'RobotoMono'),
          maxLines: 15,
          decoration:
              InputDecoration(hintText: "", border: OutlineInputBorder()),
        )));
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
            child: RaisedButton(
                child: Text(text),
                textColor: Colors.white,
                color: Colors.blueGrey,
                onPressed: () => onPressed()));
  }

  Widget _buildStatusText() {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
        child: Text(_statusText));
  }

  Future<String> loadDecryptionSample() async {
    return await rootBundle.loadString('assets/decryption_sample.base64');
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
