import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class FetchTasks extends TaskEvent {
  FetchTasks() : super([]);
}

class FetchTask extends TaskEvent {
  final int id;

  FetchTask(this.id) : super([id]);
}

class ImportTasks extends TaskEvent {
  ImportTasks() : super([]);
}