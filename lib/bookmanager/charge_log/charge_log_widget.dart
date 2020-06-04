
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/bookmanager/bloc/charge_log.dart';
import 'package:ownspace/bookmanager/model/charge_log.dart';

class ChargeLogWidget extends StatefulWidget {

  ChargeLogWidget({Key key}) : super(key: key);

  @override
  ChargeLogWidgetState createState() => ChargeLogWidgetState();
}

class ChargeLogWidgetState extends State<ChargeLogWidget> {

  ChargeLogBloc _chargeLogBloc;

  @override
  void initState() {
    _chargeLogBloc = ChargeLogBloc();
    super.initState();
  }

  void addEntry() {
    ChargeLog chargeLog = ChargeLog(null, "${DateTime.now().millisecondsSinceEpoch}");
    _chargeLogBloc.add(AddChargeLog(chargeLog));
  }

  @override
  Widget build(BuildContext context) => _buildBody();

  Widget _buildBody() {
    return BlocProvider(
        create: (context) => _chargeLogBloc,
        child: BlocBuilder<ChargeLogBloc, ChargeLogState>(
            builder: (context, state) {
              if (state is Loading) {
                return _showStatus("Loading...");
              } else if (state is InitialState) {
                _chargeLogBloc.add(ListChargeLogs());
                return _showStatus("Loading...");
              } else if (state is Finished) {
                _chargeLogBloc.add(ListChargeLogs());
                return _showStatus("Finished");
              } else if (state is Error) {
                return _showStatus("Error, while loading task: ${state.message}");
              } else if (state is ListFinished) {
                return _buildList(state.chargeLogs);
              }
            })
    );
  }

  Widget _buildList(List<ChargeLog> chargeLogs) {
    int previous = 0;

    return ListView.builder(
        itemCount: chargeLogs.length,
        itemBuilder: (context, index) {
          int timestamp = int.parse(chargeLogs[index].date);
          String datetime = DateTime.fromMillisecondsSinceEpoch(timestamp).toString();
          String date = datetime.substring(0, datetime.indexOf(" "));

          int daysDiff = DateTime
              .fromMillisecondsSinceEpoch(timestamp)
              .difference(DateTime.fromMillisecondsSinceEpoch(previous))
              .inDays;

          Widget daysDiffWidget = previous == 0
              ? Container()
              : Text("$daysDiff days on battery");

          previous = timestamp;
          return InkWell(
              onLongPress: () => _deleteDialog(chargeLogs[index]),
              child:
                  Column(
                      children: <Widget>[
                  Padding(
                  padding: EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 8),
              child:Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${date}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFeatures: [FontFeature.tabularFigures()]
                                )
                            ),
                            SizedBox(width: 16),
                            daysDiffWidget,
                            Spacer(),
                            Text("${index + 1}.", style: TextStyle(fontSize: 10))
                          ],
                        )),
                        Divider(height: 1,)
                      ]
                  )
          );
        }
    );
  }

  void _deleteDialog(ChargeLog chargeLog) {
    int timestamp = int.parse(chargeLog.date);
    String datetime = DateTime.fromMillisecondsSinceEpoch(timestamp).toString();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("Delete log from ${datetime})?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    _chargeLogBloc.add(DeleteChargeLog(chargeLog));
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }
}