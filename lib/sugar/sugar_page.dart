import 'package:flutter/material.dart';
import 'package:ownspace/sugar/model/entry.dart';
import 'package:ownspace/sugar/repository/repository.dart';
import 'entries_list.dart';
import 'chart.dart';
import 'summary.dart';
import 'entry_dialog.dart';

class SugarPage extends StatefulWidget {
  SugarPage({Key key}) : super(key: key);

  @override
  _SugarPageState createState() => _SugarPageState();
}

class _SugarPageState extends State<SugarPage> {
  var repository = Repository();

  void _showEntryDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            EntryDialog(callback: () => setState(() {})));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_summary(), _chart(), _listContainer()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEntryDialog(context),
        tooltip: 'Add entry',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _chart() => FutureBuilder(
      future: repository.chartValues(),
      builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) =>
          _handleChartFuture(snapshot, (data) {
            return CustomPaint(
                painter: Chart(data), 
                child: Container(height: 70)
            );
          }));

  _handleChartFuture(
      AsyncSnapshot<List<double>> snapshot, Function(List<double>) callback) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.hasError) {
          debugPrint("$snapshot");
          return _buildError(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return _buildError("Error :( ");
          } else {
            return callback(snapshot.data);
          }
        }
    }
  }

  Widget _summary() => FutureBuilder(
      future: repository.list(),
      builder: (BuildContext context,
              AsyncSnapshot<Map<String, List<Entry>>> snapshot) =>
          _handleEntriesFuture(snapshot, (data) {
            var allEntries = List<Entry>();
            data.values.forEach((entries) => allEntries.addAll(entries));
            return Summary(allEntries);
          }));

  _listContainer() => Expanded(
      child: FutureBuilder(
          future: repository.list(),
          builder: (BuildContext context,
                  AsyncSnapshot<Map<String, List<Entry>>> snapshot) =>
              _handleEntriesFuture(snapshot, (data) => _buildListView(data))));

  _handleEntriesFuture(AsyncSnapshot<Map<String, List<Entry>>> snapshot,
      Function(Map<String, List<Entry>>) callback) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.hasError) {
          debugPrint("$snapshot");
          return _buildError(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return _buildError("Error :( ");
          } else {
            return callback(snapshot.data);
          }
        }
    }
  }

  _buildLoadingView() => Center(
        child: CircularProgressIndicator(),
      );

  _buildError(String errorMessage) => Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(errorMessage),
      ));

  _buildListView(Map<String, List<Entry>> entries) {
    if (entries.isEmpty) {
      return _buildError("Nothing found");
    }
    return EntryList(entries);
  }
}
