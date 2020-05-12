import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/tasks/bloc/task.dart';
import 'package:path/path.dart';

class TaskPage extends StatefulWidget {

  final int taskId;

  TaskPage({Key key, this.taskId}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  TaskBloc _taskBloc;

  @override
  void initState() {
    _taskBloc = TaskBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _taskBloc,
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(title: _createAppBarTitle(context)),
              body: _createTaskBody(context)
          );
        },
      ),
    );
  }

  Widget _createTaskBody(BuildContext context) {
    TaskState state = BlocProvider.of<TaskBloc>(context).state;
    if (state is Loading) {
      return _showStatus("Loading...");
    } else if (state is InitialTaskState) {
      _taskBloc.add(FetchTask(widget.taskId));
      return _showStatus("Loading...");
    } else if (state is Finished) {
      return _showStatus("Finished?");
    } else if (state is Error) {
      return _showStatus("Error, while loading task: ${state.message}");
    } else if (state is TaskLoaded) {
      return _buildTaskView(state);
    }
  }

  Widget _buildTaskView(TaskLoaded state) {
    return Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                  state.task.content,
                style: TextStyle(fontSize: 12.0),
              )),
        )
    );
  }

  Widget _createAppBarTitle(BuildContext context) {
    TaskState state = BlocProvider.of<TaskBloc>(context).state;
    if (state is TaskLoaded) {
      return Text(state.task.name);
    } else {
      return null;
    }
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }
}