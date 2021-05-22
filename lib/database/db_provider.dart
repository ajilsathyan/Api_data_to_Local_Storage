import 'dart:io';
import 'package:bestkrok_easykrok/models/category_model.dart';
import 'package:bestkrok_easykrok/models/english_modal.dart';
import 'package:bestkrok_easykrok/models/question_model.dart';
import 'package:bestkrok_easykrok/models/russian_modal.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider();

  //DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'category_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Category('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'lang TEXT,'
          'created_at TEXT,'
          'updated_at TEXT'
          ')');
      await db.execute('CREATE TABLE English('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'lang TEXT,'
          'created_at TEXT,'
          'updated_at TEXT'
          ')');
      await db.execute('CREATE TABLE Russian('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'lang TEXT,'
          'created_at TEXT,'
          'updated_at TEXT'
          ')');
    });
  }

  // All Categories
  createCategoryDataBase(Categories categories) async {
    await deleteAllCategory();
    final db = await database;
    final res = await db.insert('Category', categories.toJson());
    return res;
  }

  //Category Based on English Language
  createCategoryEnglish(English1 english1) async {
    await deleteAllEnglishCategory();
    final db = await database;
    final res = await db.insert('English', english1.toJson());
    return res;
  }

  //Category based on Russian Language
  createCategoryRussian(Russian russian) async {
    await deleteAllRussianCategory();
    final db = await database;
    final res = await db.insert('Russian', russian.toJson());
    return res;
  }

  // Delete All Category
  Future<int> deleteAllCategory() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Category');
    return res;
  }

  // Delete All English Category
  Future<int> deleteAllEnglishCategory() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM English');
    return res;
  }

  // Delete All Russian Category
  Future<int> deleteAllRussianCategory() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Russian');
    return res;
  }

// Get All Category
  Future<List<Categories>> getAllCategory() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Category");

    List<Categories> list =
        res.isNotEmpty ? res.map((c) => Categories.fromJson(c)).toList() : [];
    return list;
  }

  // Get All English Category
  Future<List<English1>> getAllEnglishCategory() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM English");
    List<English1> list =
        res.isNotEmpty ? res.map((c) => English1.fromJson(c)).toList() : [];
    return list;
  }

  // Get All Category
  Future<List<Russian>> getAllRussianCategory() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Russian");
    List<Russian> list =
        res.isNotEmpty ? res.map((c) => Russian.fromJson(c)).toList() : [];
    return list;
  }
}
