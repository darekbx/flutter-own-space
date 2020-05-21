
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/weight/bloc/entry.dart';
import 'package:ownspace/weight/model/entry.dart';

class EntriesListPage extends StatefulWidget {

    EntriesListPage({Key key}) : super(key: key);

    @override
    _EntriesListPageState createState() => _EntriesListPageState();
}

class _EntriesListPageState extends State<EntriesListPage> {

    EntryBloc _entryBloc;

    @override
    void initState() {
        _entryBloc = EntryBloc();
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text("Entries")),
            body: Container(
                width: double.infinity,
                height: double.infinity,
                child: _buildBody()
            ),
        );
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
                        state.entries.sort((a, b) => a.date.compareTo(b.date));
                        return _showEntriesList(state.entries.reversed.toList());
                    }
                })
        );
    }

    Widget _showEntriesList(List<Entry> entries) {
        return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
                Entry entry = entries[index];
                return
                    InkWell(
                        child: ListTile(
                            title: Text("${entry.weight}"),
                            subtitle: _showDate(entry),
                            trailing: Text(_getTypeString(entry)),
                        ),
                        onLongPress: () {
                            _deleteDialog(entry);
                        }
                    );
            }
        );
    }

    String _getTypeString(Entry entry) {
        if (entry.type == 1) {
            return "Monika";
        } else if (entry.type == 2) {
            return "Darek";
        } else if (entry.type == 3) {
            return "Michał";
        }
        return "Unknown?";
    }

    Widget _showDate(Entry entry) {
        var datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(entry.date));
        return Text(datetime.toString());
    }

    Widget _showStatus(String status) {
        return Center(
                child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
        );
    }

    void _deleteDialog(Entry entry) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Delete"),
                    content: Text("Delete entry: ${entry.weight} (${_getTypeString(entry)})?"),
                    actions: <Widget>[
                        FlatButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                        FlatButton(
                            child: Text("Confirm"),
                            onPressed: () {
                                _entryBloc.add(DeleteEntry(entry));
                                Navigator.of(context).pop();
                            }
                        )
                    ],
                );
            }
        );
    }
}