import 'note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DBHelper{
  static DBHelper _dbHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colID = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';

  DBHelper._createInstance();

  factory DBHelper(){
    if(_dbHelper == null)
    _dbHelper = DBHelper._createInstance();
    return _dbHelper;
  }

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db';

    var notesDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb
          );
          return notesDatabase;
        }
      
    FutureOr<void> _createDb(Database db, int version) async {
      await db.execute(
      "CREATE TABLE $noteTable($colID INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER,$colDate TEXT)"
      );
    }

    Future<List<Map<String, dynamic>>>  getNoteMapList() async {
      Database db = await this.database;
      var result = await db.query(noteTable, orderBy: '$colPriority ASC');
      return result;
    }

    Future<int> insertNote(Note note) async{
      Database db = await this.database;
      var result = await db.insert(noteTable, note.toMap());
      return result;
    }
    Future<int> updateNote(Note note) async{
      Database db = await this.database;
      var result = await db.update(noteTable, note.toMap(),
      where: '$colID = ?',
      whereArgs: [note.id]);

      return result;
    }

    Future<int> deleteNote(int id) async{
      Database db = await this.database;
      var result = await db.delete(noteTable,where: '$colID = ?', whereArgs: [id]);
      return result;
    }

    Future<int> getNotesCount() async{
      var db = await this.database;
      var result = await db.rawQuery("SELECT COUNT(*) FROM $noteTable");
      return Sqflite.firstIntValue(result);
    }

    Future getNoteList() async {
      var noteMapList = await getNoteMapList();
      List<Note> noteList = List<Note>();
      for(var i in noteMapList){
        noteList.add(Note.fromMapObject(i));
      }
      return noteList;
    }
}