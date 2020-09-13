
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ownspace/backup/model/backup_file.dart';
import 'package:ownspace/common/database/database_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BackupCreator {

  var filePrefix = "own_space_backup_";

  /**
   * Backup file is a zip file with password, contains:
   *  - README.md
   *  - database.sqlite
   *
   *  README.md:
   *   - information about password vault encryption
   */
  Future<String> createBackup() async {
    var encoder = ZipFileEncoder();
    File outReadmeFile = await _createReadmeFile();
    String backupFileName = await _createBackupFile();
    
    String databasesPath = await getDatabasesPath();
    return Future(() {
      encoder.create(backupFileName);
      encoder.addFile(File("$databasesPath/${DatabaseProvider.DB_NAME}"));
      encoder.addFile(File(outReadmeFile.path));
      encoder.close();

      outReadmeFile.deleteSync();

    }).then((_) => backupFileName);
  }

  /**
   * Restore uses external storage directory:
   * /Android/data/com.darekbx.ownspace/files/own_space_backup_
   */
  Future<List<BackupFile>> listBackupFiles() async {
    Directory dir = await getExternalStorageDirectory();
    return dir.list()
        .where((file) => file.path.contains(filePrefix))
        .asyncMap((file) async => await mapToBackupFile(file))
        .toList();
  }

  /**
   * Restore is overriding whole data!
   */
  Future restore(BackupFile backupFile) async {
    final bytes = await File(backupFile.path).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    ArchiveFile restoredDatabase = archive
        .firstWhere((file) => file.name.startsWith(DatabaseProvider.DB_NAME));
    if (restoredDatabase != null) {

      String databasesPath = await getDatabasesPath();
      await File("$databasesPath/${DatabaseProvider.DB_NAME}").delete();

      final data = restoredDatabase.content as List<int>;
      var newDatabaseFile = File("$databasesPath/${DatabaseProvider.DB_NAME}");
      await newDatabaseFile.create(recursive: true);
      await newDatabaseFile.writeAsBytes(data);
    }
  }

  Future<BackupFile> mapToBackupFile(FileSystemEntity file) async {
    var stat = (await file.stat());
    var fileName = file.path.substring(file.path.lastIndexOf("/") + 1);
    return BackupFile(fileName, file.path, stat.modified, false);
  }

  Future<String> _createBackupFile() async {
    Directory dir = await getExternalStorageDirectory();
    return "${dir.path}/${filePrefix}${millisecondsSinceEpoch()}.zip";
  }

  Future<File> _createReadmeFile() async {
    Directory cacheDir = await getTemporaryDirectory();
    String contentsString = await rootBundle.loadString("raw/README.md");
    
    var readmeFile = File("${cacheDir.path}/readme.md");
    readmeFile.create(recursive: true);

    return await readmeFile.writeAsString(contentsString);
  }

  int millisecondsSinceEpoch() =>
      DateTime
          .now()
          .millisecondsSinceEpoch;
}
