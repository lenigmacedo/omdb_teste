import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  LocalDatabase._();
  static final LocalDatabase db = LocalDatabase._();
  static Database _database;

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "favorites.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Favorite ("
          "id TEXT UNIQUE,"
          "title TEXT,"
          "poster TEXT);");
    });
  }

  delete(id) async {
    final db = await database;

    var data = await db.delete('Favorite', where: 'id = ? ', whereArgs: [id]);

    print(data);

  }

  insert(String id, String title, String poster) async {
    final db = await database;

    try {
      var data;
      data = await db.rawInsert(
          "INSERT INTO Favorite(id,title,poster) VALUES ('$id','$title', '$poster'); ");

      return data;
    } catch (e) {
      return e;
    }
  }

  select() async {
    final db = await database;
    var data = await db.rawQuery('SELECT * from Favorite');

    return data.toList();
  }

  isFavorite(String id) async {
    final db = await database;
    var data = await db.query("Favorite",
        columns: ["id"], where: 'id = ?', whereArgs: [id]);

    if (data.length > 0) {
      return "Favorite";
    } else {
      return "No favorite";
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }
}
