
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/bookmanager/bloc/to_read.dart';
import 'package:ownspace/bookmanager/model/to_read.dart';

class ToReadWidget extends StatefulWidget {

  ToReadWidget({Key key}) : super(key: key);

  @override
  ToReadWidgetState createState() => ToReadWidgetState();
}

class ToReadWidgetState extends State<ToReadWidget> {

  ToReadBloc _toReadBloc;

  @override
  void initState() {
    _toReadBloc = ToReadBloc();
    super.initState();
  }

  void addEntry(ToRead toRead) {
    _toReadBloc.add(AddToRead(toRead));
  }

  @override
  Widget build(BuildContext context) => _buildBody();

  Widget _buildBody() {
    return BlocProvider(
        create: (context) => _toReadBloc,
        child: BlocBuilder<ToReadBloc, ToReadState>(
            builder: (context, state) {
              if (state is Loading) {
                return _showStatus("Loading...");
              } else if (state is InitialState) {
                _toReadBloc.add(ListToRead());
                return _showStatus("Loading...");
              } else if (state is Finished) {
                _toReadBloc.add(ListToRead());
                return _showStatus("Finished");
              } else if (state is Error) {
                return _showStatus("Error, while loading task: ${state.message}");
              } else if (state is ListFinished) {
                return _buildList(state.toReads);
              }
            })
    );
  }

  Widget _buildList(List<ToRead> toReads) {
    return ListView.builder(
        itemCount: toReads.length,
        itemBuilder: (context, index) {
          return InkWell(
              onLongPress: () => _deleteDialog(toReads[index]),
              child: ListTile(
                title: Text("${toReads[index].title}"),
                subtitle: Text("${toReads[index].author}")
              )
          );
        }
    );
  }

  void _deleteDialog(ToRead toRead) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Row(children: <Widget>[
              Text("Delete to read"),
              Text(" \"${toRead.author} - ${toRead.title}\"", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("?")
            ]),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    _toReadBloc.add(DeleteToRead(toRead));
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