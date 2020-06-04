

import 'package:flutter/material.dart';
import 'package:ownspace/bookmanager/bloc/book.dart';

class StatisticsWidget extends StatefulWidget {

  StatisticsWidget({Key key}) : super(key: key);

  @override
  StatisticsWidgetState createState() => StatisticsWidgetState();
}

class StatisticsWidgetState extends State<StatisticsWidget> {

  BookBloc _bookBloc;

  @override
  void initState() {
    _bookBloc = BookBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}