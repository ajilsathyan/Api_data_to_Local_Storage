import 'dart:async';
import 'package:bestkrok_easykrok/models/question_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category_model.dart';


class CatsCache {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "cats.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE cats(id INTEGER,name TEXT,lang TEXT,created_at TEXT,updated_at TEXT)",

        );
      } );
    }
  }

  Future<int> insert(Categories catModel) async {
    await openDb();
    return await _database.insert('cats', catModel.toMap());
  }
  Future<int> insertList(List<Categories> catLs) async {
    bool _isExist;
  try{

    // print("fullLeng:${catLs.length}");
    await delete();
    // await Future.delayed(Duration(seconds: 2));
    List<Categories> _ls = await get();
    // try{ var abc = _ls.firstWhere((element) {
    //   if(catLs.d == element.id){ _isExist = true; return true;  }else{
    //     _isExist = false; return false;  } },orElse:() { _isExist = false;
    // }).id ?? catModel.id; }catch(e){ _isExist = false; }


    if(_ls.isEmpty){
      int _cnt = 0;
      for (var v in catLs){

        try{ _ls.firstWhere((element) {
          if(v.id == element.id){ _isExist = true; return true;  }else{
            _isExist = false; return false;  } },orElse:() { _isExist = false;
        }).id ?? v.id; }catch(e){ _isExist = false; }
        // _cnt
        if(_isExist == false){
          await _database.insert('cats', v.toMap());
          print("Record Added: ${v.id}--$_cnt");
        }

      }

    }else{
      print("Already Added");
    }

    // print("Record Updated: $_cnt");
  }catch(e){print("Errr: Cache $e");}

  }
  Future<int> _insUnique(Categories catModel)async{
    return await _database.insert('cats', catModel.toMap());
  }
  Future insertUnique(Categories catModel)async{
    bool _isExist;
    await openDb();
    List<Categories> _localList = await get();
    try{ var abc = _localList.firstWhere((element) {
        if(catModel.id == element.id){ _isExist = true; return true;  }else{
          _isExist = false; return false;  } },orElse:() { _isExist = false;
      }).id ?? catModel.id; }catch(e){ _isExist = false; }

    if(_isExist){
      // print("Exist:${ob.id},${ob.name}");
    }else{
      // print("Not Exist:${ob.id},${ob.name}");
      try{_insUnique(catModel).then((value) => print("Added-$value-${catModel.id}-${catModel.name}"));}catch(e){print(e);}
    }



  }

  Future<List<Categories>> get() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('cats');
    return List.generate(maps.length, (i) {
      return Categories(
         id:maps[i]['id'],
         name: maps[i]['name'],
         lang: maps[i]['lang'],
          createdAt: DateTime.parse(maps[i]['created_at']),
          updatedAt: DateTime.parse(maps[i]['updated_at']),
      );
    });
  }


  Future<void> delete() async {
    await openDb();
    await _database.delete(
        'cats',
    );
  }
}



class QeustionCache {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "quecache.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE quecache(id INTEGER,question TEXT,answer TEXT,category_id INTEGER,lang TEXT,created_at TEXT,updated_at TEXT)",
        );
      } );
    }
  }

  Future<void> close()async{
    try {
      await _database.close();
    }catch (e) {
      print("Err${e}");
    }
  }

  Future<int> insert(Questions q) async {
    // await openDb();
    return await _database.insert('quecache', q.toMap());
  }

  Future<List<Questions>> get() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('quecache');

    return List.generate(maps.length, (i) {
      // print("adsfas:${maps[i]['id']}");
      return Questions(
          id:maps[i]['id'],
          question: maps[i]['question'],
          answer: maps[i]['answer'],
          categoryId:maps[i]['category_id'],
          lang:maps[i]['lang'],
          createdAt: DateTime.parse(maps[i]['created_at']),
          updatedAt: DateTime.parse(maps[i]['updated_at']));
    });
  }


  Future<bool> del(List<Questions> delList) async {
    bool _isDel = false;
   await openDb();
   for(var i in delList){
     await _database.delete(
         'quecache',
         where: "category_id = ?", whereArgs: [i.id]
     );
   }
    _isDel= true;
   return _isDel;

  }

  Future<void> delete() async {
    await openDb();
    await _database.delete(
        'quecache',
    );
  }
  Future<int> insertList(List<Questions> catLs) async {
    bool _isExist;
    try{
      // await delete();
      await del(catLs);
      List<Questions> _ls = await get();
      // if(_ls.isEmpty){
        int _cnt = 0;
        for (var v in catLs){
          try{ _ls.firstWhere((element) {
            if(v.id == element.id){ _isExist = true; return true;  }else{
              _isExist = false; return false;  } },orElse:() { _isExist = false;
          }).id ?? v.id; }catch(e){ _isExist = false; }
          // _cnt
          if(_isExist == false){
            _cnt++;
            await _database.insert('quecache', v.toMap());
            print("Record Quest: ${v.id}--$_cnt");
          }else{
            print("AlreadyExist");
          }

        }

      // }else{
      //   print("Already Added");
      // }

      // print("Record Updated: $_cnt");
    }catch(e){print("Errr: Cache $e");}

  }
}