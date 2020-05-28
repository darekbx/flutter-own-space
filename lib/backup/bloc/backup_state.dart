
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/backup/model/backup_file.dart';

@immutable
abstract class BackupState extends Equatable {
  BackupState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialBackupState extends BackupState { }

class InProgress extends BackupState { }

class RestoreFinished extends BackupState { }

class BackupFinished extends BackupState {
  final String fileName;
  BackupFinished(this.fileName) : super([fileName]);
}

class ListFinished extends BackupState {
  final List<BackupFile> files;
  ListFinished(this.files) : super([files]);
}

class Error extends BackupState {
  final String message;

  Error(this.message) : super([message]);
}