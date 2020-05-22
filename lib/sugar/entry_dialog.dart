import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/sugar/model/entry.dart';
import 'package:ownspace/sugar/repository/repository.dart';
import 'portion_calculator.dart';

class EntryDialog extends StatefulWidget {
  EntryDialog({this.callback});

  final Function() callback;
  final List<Entry> _data = List();

  @override
  _EntryDialogState createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  GlobalKey<AutoCompleteTextFieldState<Entry>> _key = new GlobalKey();
  AutoCompleteTextField _descriptionTextField;
  final _sugarController = TextEditingController();
  bool _descriptionError = false;
  bool _sugarError = false;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    _loadEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => entryDialog(context);

  @override
  void dispose() {
    _sugarController.dispose();
    super.dispose();
  }

  void _loadEntries() async {
    var entries = await Repository().distinctList();
    setState(() {
      widget._data.clear();
      widget._data.addAll(entries);
    });
  }

  AlertDialog entryDialog(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("New entry")),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _autocompleteDescription(context),
        Row(children: <Widget>[
          Flexible(flex: 3, child: _sugarInput()),
          Flexible(flex: 1, child: _calculateButton(context))
        ])
      ]),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Save"),
          onPressed: () => _saveEntry(context),
        )
      ],
    );
  }

  _autocompleteDescription(BuildContext context) {
    _descriptionTextField = AutoCompleteTextField<Entry>(
        decoration: InputDecoration(
            hintText: 'Description',
            errorText: _descriptionError ? "Description can't be empty" : null),
        itemBuilder: (context, item) => _dropDownItem(item),
        itemFilter: (item, query) => _itemFilter(item, query),
        itemSorter: (a, b) => a.name.compareTo(b.name),
        itemSubmitted: (item) {
          setState(() {
            _descriptionTextField.textField.controller.text = item.name;
            _sugarController.text = item.sugar.toString();
          });
        },
        clearOnSubmit: false,
        suggestions: widget._data,
        key: _key);
    return _descriptionTextField;
  }

  _dropDownItem(Entry entry) => Padding(
    padding: EdgeInsets.all(8.0),
    child: Text("${entry.name} (${entry.sugar}g)")
  );

  _itemFilter(item, query) => item.name.toLowerCase().startsWith(query.toLowerCase());

  _saveEntry(BuildContext context) async {
    var description = _descriptionTextField.textField.controller.text;
    var sugar = _sugarController.text;

    setState(() {
      _descriptionError = _descriptionTextField.textField.controller.text.isEmpty;
      _sugarError = _sugarController.text.isEmpty || double.tryParse(sugar) == null;
    });

    if (_descriptionError || _sugarError) {
      return;
    }

    var entry = Entry(null, description, double.parse(sugar),
        DateTime.now().millisecondsSinceEpoch);

    await Repository().add(entry);
    Navigator.pop(context);
    widget.callback();
  }

  Widget _sugarInput() => TextField(
      controller: _sugarController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Sugar [g]',
          errorText: _sugarError ? "Amount is invalid" : null));

  Widget _calculateButton(BuildContext context) => Padding(
      padding: EdgeInsets.only(left: 12.0),
      child: RaisedButton(
        child: Icon(Icons.keyboard),
        onPressed: () => _openPortionCalculator(context),
      ));


    void _openPortionCalculator(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              PortionCalculator(callback: (amount) {
                setState(() {
                  _sugarController.text = amount.toString();
                });
              }));
    }
}
