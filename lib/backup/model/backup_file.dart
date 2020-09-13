
class BackupFile {

  final String name;
  final String path;
  final DateTime modified;
  bool storedOnGDrive;

  BackupFile(this.name, this.path, this.modified, this.storedOnGDrive);
}
