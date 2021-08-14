
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ownspace/applications/currencies/domain/currencies.dart';

import '../../main.dart';
import 'domain/currencies_use_case.dart';

typedef CurrencyValueCallback = void Function(double value);

class CurrencyWidget extends StatefulWidget {

  final Currency from;
  final Currency to;
  final Color color;
  final String sign;
  final CurrencyValueCallback callback;

  CurrencyWidget({Key key, this.from, this.to, this.color, this.sign, this.callback})
      : super(key: key);

  @override
  _CurrencyWidgetState createState() => _CurrencyWidgetState();
}

class _CurrencyWidgetState extends State<CurrencyWidget> {

  double _value = null;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    await getIt.allReady();
    var currenciesUseCase = getIt<CurrenciesUseCase>();
    var value = await currenciesUseCase.convertCurrency(widget.from, widget.to);
    widget.callback.call(value);
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: (_value == null)
          ? _displayProgress()
          : _displaySign(),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle
      ),
    );
  }

  Widget _displaySign() {
    return Text(
        widget.sign,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
    );
  }

  Widget _displayProgress() =>
      SizedBox(child: CircularProgressIndicator(color: Colors.black,), width: 18, height: 18);
}
