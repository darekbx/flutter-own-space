import 'package:bloc/bloc.dart';
import 'package:ownspace/backup/backup_creator.dart';
import 'package:ownspace/backup/bloc/backup_event.dart';
import 'package:ownspace/backup/bloc/backup_state.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {

  final BackupCreator _backupCreator = BackupCreator();

  @override
  BackupState get initialState => InitialBackupState();

  @override
  Stream<BackupState> mapEventToState(BackupEvent event) async* {
    try {
      if (event is MakeBackup) {
        yield InProgress();
        String backupFileName = await _backupCreator.createBackup();
        yield BackupFinished(backupFileName);
      } else if (event is RestoreBackup) {
        await _backupCreator.restore(event.backupFile);
        yield RestoreFinished();
      } else if (event is ListBackups) {
        var files = await _backupCreator.listBackupFiles();
        yield ListFinished(files);
      }
    } on Exception catch (e) {
      yield Error(e.toString());
    }
  }
}