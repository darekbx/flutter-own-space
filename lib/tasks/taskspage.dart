import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ownspace/tasks/bloc/task.dart';
import 'package:ownspace/tasks/model/task.dart';
import 'package:ownspace/tasks/taskpage.dart';

class TasksPage extends StatefulWidget {

  final IS_IMPORT_VISIBLE = false;

  TasksPage({Key key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  TaskBloc _taskBloc;

  @override
  void initState() {
    _taskBloc = TaskBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Tasks")),
        floatingActionButton: _createImportButton(),
        body: BlocProvider(
          create: (context) => _taskBloc,
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is Loading) {
                return _showStatus("Loading...");
              } else if (state is InitialTaskState) {
                _taskBloc.add(FetchTasks());
                return _showStatus("Loading...");
              } else if (state is Finished) {
                return _showStatus("Finished?");
              } else if (state is Error) {
                return _showStatus("Error, while loading task: ${state.message}");
              } else if (state is TasksLoaded) {
                if (state.tasks.isEmpty) {
                  return _showStatus("No tasks present, please add.");
                } else {
                  return _showTasksList(state.tasks);
                }
              }
            },
          ),
        )
    );
  }

  FloatingActionButton _createImportButton() {
    if (widget.IS_IMPORT_VISIBLE) {
      return FloatingActionButton(
        onPressed: () => _taskBloc.add(ImportTasks()),
        child: Icon(Icons.add),
      );
    } else {
      return null;
    }
  }

  Widget _showStatus(String status) {
    return Center(
      child: Text(status, style: TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }

  Widget _showTasksList(List<Task> tasks) {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task task = tasks[index];
          return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => TaskPage(taskId: task.id,)));
              },
              child: ListTile(
                title: Text(task.name),
                subtitle: Text(task.date),
              ));
        }
    );
  }
}