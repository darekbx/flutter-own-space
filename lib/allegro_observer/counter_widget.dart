import 'package:flutter/material.dart';
import 'package:ownspace/allegro_observer/model/filter.dart';
import 'package:ownspace/allegro_observer/allegro/allegro_search.dart';
import 'package:ownspace/allegro_observer/repository/repository.dart';

class CounterWidget extends StatefulWidget {
  final Filter filter;
  int count = null;
  bool isOverflow = false;

  CounterWidget(this.filter, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {

  var repository = Repository();
  final mediumScale = 0.8;

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      _update();
    }
  }

  _update() async {
    var allegroSearch = AllegroSearch();
    var result = await allegroSearch.search(widget.filter);
    await repository.open();
    var newCount = await repository.addItems(widget.filter.id, result.items);
    await repository.close();
    if (this.mounted) {
      setState(() {
        widget.count = newCount;
        widget.isOverflow = result.isOverflow();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.count == null) {
      return _buildLoadingView();
    }
    Color bgColor;
    Color fontColor;
    if (widget.isOverflow) {
      bgColor = Colors.red;
      fontColor = Colors.white;
    } else {
      bgColor = widget.count <= 0 ? Colors.transparent : Colors.blue;
      fontColor = widget.count <= 0 ? Colors.black : Colors.white;
    }
    if (widget.count < 0) {
      widget.count = -widget.count;
    }
    return Container(
      child: Text(
          "${widget.count}",
          textScaleFactor: mediumScale,
          style: TextStyle(
              color: fontColor,
              fontWeight: FontWeight.bold
          )
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: bgColor
      ),
      padding: EdgeInsets.all(4.0),
    );
  }

  Widget _buildLoadingView() {
    return Container(height: 20.0, width: 20.0,
      child: CircularProgressIndicator(),
    );
  }
}