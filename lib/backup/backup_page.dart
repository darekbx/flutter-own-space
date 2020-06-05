import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/backup/model/backup_file.dart';

import 'bloc/backup.dart';

class BackupPage extends StatefulWidget {

  final int BackupId;

  BackupPage({Key key, this.BackupId}) : super(key: key);

  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {

  BackupBloc _backupBloc;

  @override
  void initState() {
    _backupBloc = BackupBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _backupBloc,
        child: Scaffold(
          appBar: AppBar(title: Text("Backup")),
          body: _createBody(),
          floatingActionButton:
          Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton.extended(
                    icon: Icon(Icons.backup),
                    label: Text("Backup"),
                    heroTag: "backup_button",
                    onPressed: () => _backupBloc.add(MakeBackup()))
              ]),
        )
    );
  }

  Widget _createBody() {
    return BlocBuilder<BackupBloc, BackupState>(
      condition: (previousState, currentState) =>
      currentState.runtimeType != previousState.runtimeType,
      builder: (context, state) {
        if (state is InProgress) {
          return _showStatus("In progress...");
        } else if (state is InitialBackupState) {
          _backupBloc.add(ListBackups());
          return Container();
        } else if (state is Error) {
          return _showStatus("Error, while loading Backup: ${state.message}");
        } else if (state is BackupFinished) {
          _backupBloc.add(ListBackups());
          return _showStatus("Backup created to: ${state.fileName}");
        } else if (state is ListFinished) {
          return _showBackups(state.files);
        } else if (state is RestoreFinished) {
          Future.delayed(Duration(milliseconds: 500)).then((_) {
            _showRestoreFinishedDialog();
          });
          return _showStatus("Backup finished");
        }
      },
    );
  }

  void _showRestoreFinishedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Data was restored."),
            actions: <Widget>[
              FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                    _backupBloc.add(ListBackups());
                  })
            ],
          );
        });
  }
  
  Widget _showBackups(List<BackupFile> files) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        return ListTile(
                title: Text("${files[index].name}"),
                subtitle: Text("${files[index].modified}"),
                onTap: () => _restoreConfirmation(files[index]),
            );
      },
    );
  }

  Widget _showStatus(String status) {
    return Center(
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14))
      ),
    );
  }

  void _restoreConfirmation(BackupFile file) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Restore"),
            content: Container(child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Restore from backup?"),
                  Text("${file.name}\n${file.modified}?",
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                  SizedBox(height: 20.0),
                  Text("THIS WILL OVERRIDE ALL DATA!",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                  )
                ])),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    _backupBloc.add(RestoreBackup(file));
                    Navigator.pop(context);
                  }
              )
            ],
          );
        }
    );
  }
}