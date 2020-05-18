
import 'package:flutter/material.dart';
import 'package:ownspace/weight/repository/entriesrepository.dart';

class WeightPage extends StatefulWidget {

  final IS_IMPORT_VISIBLE = false;

  WeightPage({Key key}) : super(key: key);

  @override
  _WeightPageState createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {

  String _count = "Count: 0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_count)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.import_export),
        onPressed: () async {

          var list = await EntriesRepository().fetchEntries();
          setState(() {
            _count = "Count: ${list.length}";
          });
        },
      ),
      body: Container(),
    );
  }
}