
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/common/bloc/appbar_bloc.dart';
import 'package:ownspace/fuel/bloc/fuel.dart';
import 'package:ownspace/fuel/fuel_chart_page.dart';
import 'package:ownspace/fuel/fuel_entry_dialog.dart';
import 'package:ownspace/fuel/model/fuel_entry.dart';

class FuelPage extends StatefulWidget {

  final IS_IMPORT_VISIBLE = false;

  FuelPage({Key key}) : super(key: key);

  @override
  _FuelPageState createState() => _FuelPageState();
}

class _FuelPageState extends State<FuelPage> {

  FuelEntryBloc _fuelEntryBloc;
  AppBarBloc _appBarBloc;

  @override
  void initState() {
    _fuelEntryBloc = FuelEntryBloc();
    _appBarBloc = AppBarBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _buildTitle()),
      floatingActionButton:
      Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
                child: Icon(Icons.add),
                heroTag: "add_button",
                onPressed: () {
                  _showAddDialog();
                }),
            SizedBox(
              height: 16.0,
            ),
            FloatingActionButton(
                child: Icon(Icons.show_chart),
                heroTag: "chart_button",
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => FuelChartPage()));
                }),
            _buildImportButton()
          ]),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: _buildBody()
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            FuelEntryDialog(callback: (entry) {
              _fuelEntryBloc.add(AddFuelEntry(entry));
            }));
  }

  Widget _buildBody() {
    return BlocProvider(
        create: (context) => _fuelEntryBloc,
        child: BlocBuilder<FuelEntryBloc, FuelEntryState>(
            builder: (context, state) {
              if (state is Loading) {
                return _showStatus("Loading...");
              } else if (state is InitialFuelEntryState) {
                _fuelEntryBloc.add(FetchFuelEntries());
                return _showStatus("Loading...");
              } else if (state is Finished) {
                return _showStatus("Finished?");
              } else if (state is Error) {
                return _showStatus("Error, while loading task: ${state.message}");
              } else if (state is FuelEntriesLoaded) {
                _appBarBloc.updateTitle("Entries: ${state.entries.length}");
                return _showFuelEntriesList(state.entries);
              }
            })
    );
  }

  Widget _showFuelEntriesList(List<FuelEntry> entries) {
    return Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    FuelEntry entry = entries[index];
                    return
                      InkWell(
                          child: ListTile(
                            leading: _getTypeIcon(entry.getTypeIconAsset()),
                            title: Text(
                                "${entry.cost.toStringAsFixed(2)}zł / ${entry.liters
                                    .toStringAsFixed(
                                    2)}L"),
                            subtitle: Text("${entry.pricePerLiter().toStringAsFixed(2)}zł/L"),
                            trailing: _showDate(entry),
                          ),
                          onLongPress: () {
                            _deleteDialog(entry);
                          }
                      );
                  }
              )),
          Container(child: _drawSummary(entries))
        ]);
  }

  Widget _drawSummary(List<FuelEntry> entries) {
    double litersSum = entries.map((entry) => entry.liters).reduce((a, b) => a + b);
    double costSum = entries.map((entry) => entry.cost).reduce((a, b) => a + b);
    return Container(
        width: double.infinity,
        color: Colors.green,
        child: Padding(
            padding: EdgeInsets.only(left: 22, top: 4, bottom: 4),
            child: RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Baloo'),
                    children: <TextSpan>[
                      TextSpan(text: 'Total cost: '),
                      TextSpan(
                          text: '${costSum.toInt()}zł',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ', Total liters: '),
                      TextSpan(
                          text: '${litersSum.toInt()}L',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ]))
        ));
  }

  Widget _getTypeIcon(String asset) {
    return Padding(
      child: Image.asset(asset, width: 32, height: 32),
      padding: EdgeInsets.only(top: 5, left: 5),
    );
  }

  Widget _showDate(FuelEntry fuelEntry) {
    var millis = (int.parse(fuelEntry.date) * 1000).toInt();
    var datetime = DateTime.fromMillisecondsSinceEpoch(millis).toString();
    return Text(datetime.substring(0, datetime.indexOf(" ")));
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }

  void _deleteDialog(FuelEntry fuelEntry) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("Delete entry: ${fuelEntry.liters}L?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    _fuelEntryBloc.add(DeleteFuelEntry(fuelEntry));
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }

  Widget _buildImportButton() {
    if (widget.IS_IMPORT_VISIBLE) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            FloatingActionButton(
                child: Icon(Icons.import_export),
                heroTag: "import_button",
                onPressed: () async {
                  _fuelEntryBloc.add(ImportFuelEntries());
                })
          ]);
    }
    return SizedBox();
  }

  Widget _buildTitle() {
    return StreamBuilder<Object>(
        stream: _appBarBloc.titleStream,
        initialData: "Entries",
        builder: (context, value) {
          return Text("${value.data}");
        }
    );
  }
}