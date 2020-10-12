import 'package:bloc/bloc.dart';
import 'package:ownspace/autobackup/AutoBackup.dart';
import 'package:ownspace/backup/backup_creator.dart';
import 'package:ownspace/backup/bloc/backup_event.dart';
import 'package:ownspace/backup/bloc/backup_state.dart';
import 'package:ownspace/backup/model/backup_file.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {

  final BackupCreator _backupCreator = BackupCreator();
  //final AutoBackup _autoBackup = AutoBackup();

  @override
  BackupState get initialState => InitialBackupState();

  @override
  Stream<BackupState> mapEventToState(BackupEvent event) async* {
    try {
      if (event is MakeBackup) {
        yield InProgress();
        String backupFileName = await _backupCreator.createBackup();
        //_autoBackup.uploadFile(backupFileName);
        yield BackupFinished(backupFileName);
      } else if (event is RestoreBackup) {
        await _backupCreator.restore(event.backupFile);
        yield RestoreFinished();
      } else if (event is ListBackups) {

        var files = await _backupCreator.listBackupFiles();
        //var driveFiles = (await _autoBackup.listGoogleDriveFiles());

        /*files.forEach((file) {
          var storedOnDrive = driveFiles.any((driveFile) => driveFile.name == file.name);
          file.storedOnGDrive = storedOnDrive;
        });*/

        files.sort((a, b) => a.modified.compareTo(b.modified));
        yield ListFinished(files);
      }
    } on Exception catch (e) {
      yield Error(e.toString());
    }
  }
}
