import 'dart:io';
import 'package:bestkrok_easykrok/models/question_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuestionDbProvider {
  static Database _database;
  static final QuestionDbProvider db = QuestionDbProvider._();
  QuestionDbProvider._();
  //DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) {
      print("Db Exists");
      return _database;
    }
    // If database don't exists, create one
    _database = await initQBDB();

    return _database;
  }

  // Create the database and the Employee table
  initQBDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'question_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Question('
          'id INTEGER PRIMARY KEY,'
          'question TEXT,'
          'answer TEXT,'
          'category_id INTEGER,'
          'lang TEXT,'
          'created_at TEXT,'
          'updated_at TEXT'
          ')');
    });
  }

  // Create DataBase For All Questions
  createCategoryQuestions(Questions questions) async {
    final db = await database;
    final res = await db.insert('Question', questions.toJson());
    return res;
  }

  Future<List<Questions>> getQuestionById(int id) async {
    final db = await database;
    var result =
        await db.query('Question', where: 'category_id = ?', whereArgs: [id]);
    List<Questions> list = result.isNotEmpty
        ? result.map((c) => Questions.fromJson(c)).toList()
        : [];
    print(list);
    return list;
  }

  Future<List<Questions>> getAllEnglishCategory() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Question");
    List<Questions> list =
        res.isNotEmpty ? res.map((c) => Questions.fromJson(c)).toList() : [];
    return list;
  }
}
