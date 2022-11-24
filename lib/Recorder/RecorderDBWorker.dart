import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../utils.dart' as utils;
import 'RecorderModel.dart';

class RecorderDBWorker
{
  RecorderDBWorker._();
  static final RecorderDBWorker db = RecorderDBWorker._();
  Database _db;

  Future get database async {
    _db ??= await init();

    return _db;
  }

  Future<Database> init() async {
    String path = join(utils.docsDir.path, "rec.db");
    Database db = await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
          await inDB.execute(
              "CREATE TABLE IF NOT EXISTS notes ("
                  "id INTEGER PRIMARY KEY,"
                  "title TEXT,"
                  "color TEXT,"
                  "content TEXT"
                  ")"
          );
        }
    );

    return db;
  }

  Recorder noteFromMap(Map inMap)
  {
    Recorder recorder = Recorder();
    recorder.id = inMap["id"];
    recorder.title = inMap['title'];
    recorder.content = inMap['content'];
    recorder.color = inMap['color'];
    return recorder;
  }

  Map<String, dynamic> noteToMap(Recorder inRecorder)
  {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = inRecorder.id;
    map['title'] = inRecorder.title;
    map['content'] = inRecorder.content;
    map['color'] = inRecorder.color;
    return map;
  }

  Future create(Recorder inRecorder) async {
    Database db = await database;
    var val = await db.rawQuery(
        "Select MAX(id) + 1 as id FROM notes"
    );
    Map note = val.first;
    int id =  note["id"];

    if (id == null) {
      id = 1;
    }

    return await db.rawInsert(
        "INSERT INTO notes (id, title, content, color) "
            "VALUES (?, ?, ?, ?)",
        [id, inRecorder.title, inRecorder.content, inRecorder.color]
    );
  }

  Future<Recorder> get(int inID) async {
    Database db = await database;
    var rec = await db.query(
        "notes", where: "id = ?", whereArgs: [inID]
    );
    return noteFromMap(rec.first);
  }

  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("notes");
    var list = recs.isNotEmpty ?
    recs.map((m) => noteFromMap(m)).toList() : [];
    return list;
  }

  Future update(Recorder inRecorder) async {
    Database db = await database;
    return await db.update(
        "notes",
        noteToMap(inRecorder),
        where : "id = ?",
        whereArgs: [inRecorder.id]
    );
  }

  Future delete(int inID) async
  {
    Database db = await database;
    return await db.delete("notes", where: "id = ?", whereArgs: [inID]);
  }
}