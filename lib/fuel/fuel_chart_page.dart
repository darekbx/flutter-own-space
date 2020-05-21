
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/common/bloc/appbar_bloc.dart';
import 'package:ownspace/fuel/bloc/fuel.dart';
import 'package:ownspace/fuel/fuel_chart_painter.dart';

class FuelChartPage extends StatefulWidget {

  FuelChartPage({Key key}) : super(key: key);

  @override
  _FuelChartPageState createState() => _FuelChartPageState();
}

class _FuelChartPageState extends State<FuelChartPage> {

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
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: _buildBody()
      ),
    );
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
                return CustomPaint(painter: FuelChartPainter(state.entries.reversed.toList()));
              }
            })
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
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