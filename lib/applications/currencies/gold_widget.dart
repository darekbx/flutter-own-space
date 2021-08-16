
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../main.dart';
import 'domain/gold_use_case.dart';

typedef GoldValueCallback = void Function(double value);

class GoldWidget extends StatefulWidget {

  final Color color;
  final String sign;
  final GoldValueCallback callback;

  GoldWidget({Key key, this.color, this.sign, this.callback})
      : super(key: key);

  @override
  _GoldWidgetState createState() => _GoldWidgetState();
}

class _GoldWidgetState extends State<GoldWidget> {

  double _value = null;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    await getIt.allReady();
    var goldUseCase = getIt<GoldUseCase>();
    var value = await goldUseCase.krugerrandPrice();
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
