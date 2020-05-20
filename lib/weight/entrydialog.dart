
import 'package:flutter/material.dart';
import 'package:ownspace/weight/model/entry.dart';

class EntryDialog extends StatefulWidget {

  EntryDialog({this.callback});

  final Function(Entry entry) callback;

  @override
  _EntryDialogState createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {

  final _weightController = TextEditingController();
  final _weightFormKey = GlobalKey<FormState>();
  int _radioType = 1;

  @override
  Widget build(BuildContext context) => _entryDialog();

  Widget _entryDialog() {
    return AlertDialog(
      title: Center(child: Text("New entry")),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _weightInput(),
            _createRadio(1, "Monika"),
            _createRadio(2, "Darek"),
            _createRadio(3, "Michał")
          ]),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Save"),
          onPressed: () => _saveEntry(),
        )
      ],
    );
  }

  Widget _createRadio(int type, String name) =>
      InkWell(
          child: Row(children: <Widget>[
            Radio(value: type, groupValue: _radioType, onChanged: _handleTypeChanged),
            Text(name)
          ]),
          onTap: () => _handleTypeChanged(type)
      );

  Widget _weightInput() =>
      Form(
          key: _weightFormKey,
          child: TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter value';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Weight [kg]'))
      );

  void _handleTypeChanged(int value) {
    setState(() {
      _radioType = value;
    });
  }

  void _saveEntry() {
    if (_weightFormKey.currentState.validate()) {
      widget.callback(Entry(
          null,
          "${DateTime.now().millisecondsSinceEpoch}",
          double.parse(_weightController.text),
          _radioType));
      Navigator.pop(context);
    }
  }
}