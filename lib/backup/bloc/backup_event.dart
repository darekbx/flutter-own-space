import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:ownspace/backup/model/backup_file.dart';

@immutable
abstract class BackupEvent extends Equatable {
  const BackupEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class MakeBackup extends BackupEvent {
  MakeBackup() : super([]);
}

class ListBackups extends BackupEvent {
  ListBackups() : super([]);
}

class RestoreBackup extends BackupEvent {
  final BackupFile backupFile;
  RestoreBackup(this.backupFile) : super([backupFile]);
}
