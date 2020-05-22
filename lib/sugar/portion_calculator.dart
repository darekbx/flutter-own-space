import 'package:flutter/material.dart';

class PortionCalculator extends StatefulWidget {
  PortionCalculator({this.callback});

  final Function(double amount) callback;

  @override
  _PortionCalculatorState createState() => _PortionCalculatorState();
}

class _PortionCalculatorState extends State<PortionCalculator> {
  final _weightController = TextEditingController();
  final _sugarWeightController = TextEditingController();
  final _portionWeightController = TextEditingController();
  final _resultController = TextEditingController();

  @override
  void initState() {
    _weightController.addListener(() => _calculatePortion());
    _sugarWeightController.addListener(() => _calculatePortion());
    _portionWeightController.addListener(() => _calculatePortion());
    super.initState();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _sugarWeightController.dispose();
    _portionWeightController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Calculate")),
      content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _defaultInput("Weight [g]", _weightController),
        _defaultInput("Sugar weight [g]", _sugarWeightController),
        _defaultInput("Portion weight [g]", _portionWeightController),
        _defaultInput("0g", _resultController)
      ])),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Apply"),
          onPressed: () {
            var result = _resultController.text;
            if (result.isEmpty) {
              result = "0";
            }
            widget.callback(double.parse(result));
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget _defaultInput(String hint, TextEditingController controller) =>
      TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: hint));

  void _calculatePortion() {
    var portionWeight = double.tryParse(_portionWeightController.text);
    var sugarWeight = double.tryParse(_sugarWeightController.text);
    var weight = double.tryParse(_weightController.text);
    if (portionWeight != null && sugarWeight != null && weight != null) {
      var result = portionWeight * sugarWeight / weight;
      _resultController.text = result.toStringAsFixed(1);
    } else {
      _resultController.text = "0";
    }
  }
}
