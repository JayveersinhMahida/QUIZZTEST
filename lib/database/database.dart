import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:quizapp/model/questions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelp {
  static const _dbName = "myQuizz.db";
  static const _dbVersion = 1;
  static const _tablename = "Quizz";
  static const columnid = "_id";
  static const question = "Questions";
  static const option1 = "Option1";
  static const option2 = "Option2";
  static const option3 = "Option3";
  static const option4 = "Option4";
  static const answer = "Answer";

  DataBaseHelp._privateConstructor();
  static final DataBaseHelp instance = DataBaseHelp._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path,
        version: _dbVersion, onCreate: _createTable);
  }

  Future _createTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tablename(
      $columnid INTEGER PRIMARY KEY,
      $question TEXT NOT NULL,
      $option1 TEXT NOT NULL,
      $option2 TEXT NOT NULL,
      $option3 TEXT NOT NULL,
      $option4 TEXT NOT NULL,
      $answer TEXT NOT NULL)
    ''');
  }

  Future<int?> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(_tablename, row);
  }

  Future<List<Questions>> queryAll() async {
    Database? db = await instance.database;
    List<Questions> que = [];

    var data = await db!.query(_tablename, orderBy: "RANDOM()", limit: 10);
    for (var i = 0; i < data.length; i++) {
      que.add(Questions(
        awnser: data[i]['Answer'].toString(),
        id: data[i]['_id'].toString(),
        options: [
          data[i]['Option1'].toString(),
          data[i]['Option2'].toString(),
          data[i]['Option3'].toString(),
          data[i]['Option4'].toString(),
        ],
        question: data[i]['Questions'].toString(),
      ));
    }

    return que;
  }
}
