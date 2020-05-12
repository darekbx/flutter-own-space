
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/tasks/model/task.dart';

@immutable
abstract class TaskState extends Equatable {
  TaskState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialTaskState extends TaskState { }

class Loading extends TaskState { }

class Finished extends TaskState { }

class TasksLoaded extends TaskState {
  final List<Task> tasks;

  TasksLoaded(this.tasks) : super([tasks]);
}

class TaskLoaded extends TaskState {
  final Task task;

  TaskLoaded(this.task) : super([task]);
}

class Error extends TaskState {
  final String message;

  Error(this.message) : super([message]);
}