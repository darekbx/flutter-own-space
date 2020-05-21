import 'package:ownspace/common/database/database_provider.dart';
import 'package:ownspace/tasks/model/task.dart';
import 'package:flutter/services.dart' show rootBundle;

class TasksRepository {

  final String LEGACY_BACKUP_FILE = "raw/tasks.bpk";

  Future import() async {
    String contents = await rootBundle.loadString(LEGACY_BACKUP_FILE);
    final String taskDelimiter = "###";
    final String itemDelimiter = "%%";

    List<Task> legacyTasks = contents
        .split(taskDelimiter)
        .where((line) => line.length > 0)
        .map((line) => _mapLineToTask(line, itemDelimiter))
        .toList();
    await _addTasks(legacyTasks);
  }

  Task _mapLineToTask(String line, String itemDelimiter) {
    List<String> chunks = line.split(itemDelimiter);
    String name = chunks[0];
    String flag = chunks[1];
    String date = chunks[2];
    String content = chunks[3];
    return Task(null, name, content, date, int.tryParse(flag));
  }

  Future<Task> fetchTask(int id) async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor = await db.query(
        DatabaseProvider.TASKS_TABLE,
        where: "id = ?",
        whereArgs: [id]
    );
    db.close();
    if (cursor.length == 0) {
      return null;
    }
    return Task.fromEntity(cursor.first);
  }

  Future<List<Task>> fetchTasks() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor =
      await db.query(DatabaseProvider.TASKS_TABLE, columns: ["id", "name", "date", "flag"]);
    db.close();
    return cursor.map((row) => Task.fromEntity(row)).toList();
  }

  Future _addTasks(List<Task> tasks) async {
    var db = await DatabaseProvider().open();
    await Future.forEach(tasks, (task) async {
      await db.insert(DatabaseProvider.TASKS_TABLE, task.toMap());
    });
    db.close();
  }
}