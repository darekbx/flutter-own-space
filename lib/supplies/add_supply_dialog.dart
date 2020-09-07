import 'package:flutter/material.dart';
import 'package:ownspace/supplies/model/supply.dart';

class AddSupplyDialog extends StatefulWidget {

  AddSupplyDialog({this.callback});

  final Function(Supply supply) callback;

  @override
  _AddSupplyDialogState createState() => _AddSupplyDialogState();
}

class _AddSupplyDialogState extends State<AddSupplyDialog> {

  final _nameController = TextEditingController();
  final _nameFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => _addSupplyDialog();

  Widget _addSupplyDialog() {
    return AlertDialog(
      title: Center(child: Text("Add supply")),
      content: _nameInput(),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Save"),
          onPressed: () => _saveAddSupply(),
        )
      ],
    );
  }

  Widget _nameInput() =>
      Form(
          key: _nameFormKey,
          child: TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter value';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Supply name'))
      );


  void _saveAddSupply() {
    if (_nameFormKey.currentState.validate()) {
      widget.callback(
          Supply(null, _nameController.text, amount: 0)
      );
      Navigator.pop(context);
    }
  }
}
