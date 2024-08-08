// lib/db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "notes.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, v) async => await db.execute(
            "CREATE TABLE NOTES(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT);"),
        version: _version);
  }

  static Future<void> addNote(Note note) async {
    final db = await _getDB();
    await db.insert("NOTES", note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateNote(int id, Note note) async {
    final db = await _getDB();
    await db.update("NOTES", note.toJson(),
        where: "id = ?",
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteNote(int id) async {
    final db = await _getDB();
    await db.delete("NOTES", where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Note>?> getNotes() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> map = await db.query("NOTES");
    if (map.isEmpty) {
      return null;
    }
    return List.generate(map.length, (index) => Note.fromJson(map[index]));
  }
}
