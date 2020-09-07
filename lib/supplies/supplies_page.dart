import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/supplies/add_supply_dialog.dart';
import 'package:ownspace/supplies/bloc/supply.dart';
import 'package:ownspace/supplies/model/supply.dart';

class SuppliesPage extends StatefulWidget {

  SuppliesPage({Key key}) : super(key: key);

  @override
  _SuppliesPageState createState() => _SuppliesPageState();
}

class _SuppliesPageState extends State<SuppliesPage> {

  SupplyBloc _supplyBloc;

  @override
  void initState() {
    _supplyBloc = SupplyBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Supplies")),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            heroTag: "add_button",
            onPressed: () {
              _showAddDialog();
            }),
        body: BlocProvider(
          create: (context) => _supplyBloc,
          child: BlocBuilder<SupplyBloc, SupplyState>(
            builder: (context, state) {
              if (state is Loading) {
                return _showStatus("Loading...");
              } else if (state is InitialSupplyState) {
                _supplyBloc.add(FetchSupplies());
                return _showStatus("Loading...");
              } else if (state is Finished) {
                return _showStatus("Finished?");
              } else if (state is Error) {
                return _showStatus("Error, while loading supply: ${state.message}");
              } else if (state is SuppliesLoaded) {
                if (state.entries.isEmpty) {
                  return _showStatus("No supplies present, please add.");
                } else {
                  return _showSuppliesList(state.entries);
                }
              }
            },
          ),
        )
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }

  Widget _showSuppliesList(List<Supply> supplies) {
    return ListView.builder(
        itemCount: supplies.length,
        itemBuilder: (context, index) {
          Supply supply = supplies[index];
          return InkWell(
              child: Row(
                  children: <Widget>[
              Expanded(child:Padding(child: Text(supply.name), padding: EdgeInsets.all(8))),

                    Row(
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.add_circle), onPressed: () {
                            _supplyBloc.add(IncreaseSupply(supply));
                          }),
                          Text("${supply.amount}", style: TextStyle(fontFeatures: [FontFeature.tabularFigures()])),
                          IconButton(icon: Icon(Icons.do_not_disturb_on), onPressed: () {
                            _supplyBloc.add(DecreaseSupply(supply));
                          }),
                        ])
                  ]),
              onLongPress: () {
                _deleteDialog(supply);
              }
          );
        }
    );
  }

  void _showAddDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AddSupplyDialog(callback: (supply) {
              _supplyBloc.add(AddSupply(supply));
            }));
  }

  void _deleteDialog(Supply supply) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("Delete supply: ${supply.name}?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    _supplyBloc.add(DeleteSupply(supply));
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }
}
