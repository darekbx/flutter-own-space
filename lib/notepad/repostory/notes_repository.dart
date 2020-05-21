import 'package:ownspace/common/database/database_provider.dart';
import 'package:ownspace/notepad/model/note.dart';

class NotesRepository {

  Future<String> fetchNote(int index) async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor = await db.query(
        DatabaseProvider.NOTES_TABLE,
        columns: ["contents"],
        where: "index = ?",
        whereArgs: [index]
    );
    db.close();
    if (cursor.length == 0) {
      return "";
    }
    return cursor.first["contents"];
  }

  Future<List<Note>> fetchNotes() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor =
      await db.query(DatabaseProvider.NOTES_TABLE, columns: ["index", "contents"]);
    db.close();
    return cursor.map((row) => Note.fromEntity(row)).toList();
  }

  Future updateNote(int index, String contents) async {
    var db = await DatabaseProvider().open();
    await db.update(
        DatabaseProvider.NOTES_TABLE,
        { "contents": contents },
        where: "`index` = ?",
        whereArgs: [index]
    );
    db.close();
  }

  Future addNote(Note note) async {
    var db = await DatabaseProvider().open();
    await db.insert(DatabaseProvider.NOTES_TABLE, note.toMap());
    db.close();
  }
}