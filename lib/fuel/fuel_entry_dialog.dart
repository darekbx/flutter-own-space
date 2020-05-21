
import 'package:flutter/material.dart';
import 'package:ownspace/fuel/model/fuel_entry.dart';

class FuelEntryDialog extends StatefulWidget {

  FuelEntryDialog({this.callback});

  final Function(FuelEntry entry) callback;

  @override
  _FuelEntryDialogState createState() => _FuelEntryDialogState();
}

class _FuelEntryDialogState extends State<FuelEntryDialog> {

  final _litersController = TextEditingController();
  final _costController = TextEditingController();
  final _weightFormKey = GlobalKey<FormState>();
  int _radioType = 1; // Defaut is Gasoline

  @override
  Widget build(BuildContext context) => _entryDialog();

  Widget _entryDialog() {
    return AlertDialog(
      title: Center(child: Text("New entry")),
      content:
      Form(
          key: _weightFormKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _litersInput(),
                _costInput(),
                _createRadio(0, "Diesel"),
                _createRadio(1, "Gasoline"),
              ])
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Save"),
          onPressed: () => _saveFuelEntry(),
        )
      ],
    );
  }

  Widget _createRadio(int type, String name) =>
      InkWell(
          child: Row(children: <Widget>[
            _getTypeIcon(type),
            Radio(value: type, groupValue: _radioType, onChanged: _handleTypeChanged),
            Text(name)
          ]),
          onTap: () => _handleTypeChanged(type)
      );

  Widget _getTypeIcon(int type) {
    String asset = "icons/ic_fuel95.png";
    if (type == 0) {
      asset = "icons/ic_diesel.png";
    }
    return Padding(
      child: Image.asset(asset, width: 24, height: 24),
      padding: EdgeInsets.only(right: 0),
    );
  }

  Widget _litersInput() =>
      TextFormField(
          controller: _litersController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter correct value';
            }
            return null;
          },
          decoration: InputDecoration(hintText: 'Liters [L]'));

  Widget _costInput() =>
      TextFormField(
          controller: _costController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter correct value';
            }
            return null;
          },
          decoration: InputDecoration(hintText: 'Price [zł]'));

  void _handleTypeChanged(int value) {
    setState(() {
      _radioType = value;
    });
  }

  void _saveFuelEntry() {
    if (_weightFormKey.currentState.validate()) {
      widget.callback(FuelEntry(
          null,
          "${_timestampSeconds()}",
          double.parse(_litersController.text),
          double.parse(_costController.text),
          _radioType));
      Navigator.pop(context);
    }
  }

  int _timestampSeconds() =>
      (DateTime
          .now()
          .millisecondsSinceEpoch / 1000).toInt();
}