import 'package:bloc/bloc.dart';
import 'package:ownspace/tasks/model/task.dart';
import 'package:ownspace/tasks/repository/tasks_repository.dart';

import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final TasksRepository _tasksRepository = TasksRepository();

  @override
  TaskState get initialState => InitialTaskState();

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is FetchTasks) {
      yield Loading();
      yield* _mapFetchTasksToState();
    } else if (event is FetchTask) {
      yield Loading();
      yield* _mapFetchTaskToState(event.id);
    } else if (event is ImportTasks) {
      yield Loading();
      await _tasksRepository.import();
      add(FetchTasks());
    }
  }

  Stream<TaskState> _mapFetchTaskToState(int id) async* {
    try {
      Task task = await _tasksRepository.fetchTask(id);
      yield TaskLoaded(task);
    } catch (e) {
      yield Error(e.errMsg());
    }
  }

  Stream<TaskState> _mapFetchTasksToState() async* {
    try {
      List<Task> tasks = await _tasksRepository.fetchTasks();
      yield TasksLoaded(tasks);
    } catch (e) {
      yield Error(e.errMsg());
    }
  }
}