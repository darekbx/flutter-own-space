
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/common/bloc/appbarbloc.dart';
import 'package:ownspace/weight/bloc/entry.dart';
import 'package:ownspace/weight/chartpainter.dart';

class WeightPage extends StatefulWidget {

  final IS_IMPORT_VISIBLE = false;

  WeightPage({Key key}) : super(key: key);

  @override
  _WeightPageState createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {

  EntryBloc _entryBloc;
  AppBarBloc _appBarBloc;

  @override
  void initState() {
    _entryBloc = EntryBloc();
    _appBarBloc = AppBarBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _buildTitle()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.import_export),
        onPressed: () async {
          //_showAddDialog();
          //var list = await EntriesRepository().import();
        },
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: _buildBody()
      ),
    );
  }

  Widget _buildTitle() {
    return StreamBuilder<Object>(
        stream: _appBarBloc.titleStream,
        initialData: "Weight",
        builder: (context, value) {
          return Text("${value.data}");
        }
    );
  }

  void _showAddDialog() {

  }

  Widget _buildBody() {
    return BlocProvider(
        create: (context) => _entryBloc,
        child: BlocBuilder<EntryBloc, EntryState>(
            builder: (context, state) {
              if (state is Loading) {
                return _showStatus("Loading...");
              } else if (state is InitialEntryState) {
                _entryBloc.add(FetchEntries());
                return _showStatus("Loading...");
              } else if (state is Finished) {
                return _showStatus("Finished?");
              } else if (state is Error) {
                return _showStatus("Error, while loading task: ${state.message}");
              } else if (state is EntriesLoaded) {
                _appBarBloc.updateTitle("Count: ${state.entries.length}");
                return CustomPaint(painter: ChartPainter(state.entries, state.maxWeight, state.minWeight));
              }
            })
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }
}