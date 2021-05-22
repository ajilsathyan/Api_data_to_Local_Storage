import 'dart:collection';
import 'dart:convert';

import 'package:bestkrok_easykrok/database/db_provider.dart';
import 'package:bestkrok_easykrok/models/category_model.dart';
import 'package:bestkrok_easykrok/models/english_modal.dart';
import 'package:bestkrok_easykrok/models/question_model.dart';
import 'package:bestkrok_easykrok/models/russian_modal.dart';
import 'package:bestkrok_easykrok/services/localbase.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final dataController =
    ChangeNotifierProvider<CatsReposit>((ref) => CatsReposit());
final questionCtrl =
    ChangeNotifierProvider<QuestionReposit>((ref) => QuestionReposit());

class CatsReposit with ChangeNotifier {
  List<Categories> _latestCatsData = [];
  UnmodifiableListView<Categories> get latestCatsData =>
      UnmodifiableListView(_latestCatsData);

  bool _isCatsUpdated = false;
  set isCatsUpdated(bool b) {
    _isCatsUpdated = b;
  }

  bool get isCatsUpdated => _isCatsUpdated;

  String _language;
  set language(String s) {
    _language = s;
  }

  String get language => _language;

  CatsCache catsCache = CatsCache();
  final Connectivity cnctvty = Connectivity();

  Future notify() async {
    String _currntLang = await getLanguage();
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await cnctvty.checkConnectivity();
      print("Connection:$result");

      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        await _latestCatsData.clear();
        final List<Categories> _getData =
            await getCategoryByLanguage(lang: _currntLang);
        final List<Categories> _updateData = await updateCategoryData(_getData);
        // if(_updateData.isNotEmpty){
        //   print("updatedIsLive:${_updateData.length}");
        //   yield _updateData;
        // }
        print("Reloaded:${_updateData.length}");
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Stream<List<Categories>> controllor() async* {
    final List<Categories> _cacheData = await _catsCache();
    if (_cacheData.isNotEmpty) {
      yield _cacheData;
    }

    ConnectivityResult result = ConnectivityResult.none;
    String _currntLang = await getLanguage();

    try {
      result = await cnctvty.checkConnectivity();
      print("Connection:$result");
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        final List<Categories> _getData =
            await getCategoryByLanguage(lang: _currntLang);
        final List<Categories> _updateData = await updateCategoryData(_getData);
        if (_updateData.isNotEmpty) {
          print("updatedIsLive2$_currntLang:${_updateData.length}");
          yield _updateData;
        }
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
    // final List<Categories> _get
  }

  Future<String> getLanguage() async {
    try {
      final SharedPreferences _shrPref = await SharedPreferences.getInstance();
      // _language = _shrPref.getString('language') ?? 'english';
      language = _shrPref.getString('language') ?? 'english';
    } catch (e) {
      print(e);
    }

    return language;
  }

  Future<List<Categories>> getCategoryByLanguage({String lang}) async {
    List<Categories> _cat;
    try {
      if (language == 'english') {
        String url = 'https://bestkrok.help/api/getCategoryByLanguage/$lang';

        Response response = await Dio().get(url);
        return (response.data as List).map((language) {
          // print("Inserting based on English language $language");
          DBProvider.db.createCategoryEnglish(English1.fromJson(language));
        }).toList();
      } else if (language == 'russian') {
        String url = 'https://bestkrok.help/api/getCategoryByLanguage/$lang';
        Response response = await Dio().get(url);
        return (response.data as List).map((language) {
          // print("Inserting based on Russian language $language");
          DBProvider.db.createCategoryRussian(Russian.fromJson(language));
        }).toList();
      }

      Comparator<Categories> _compare = (a, b) => a.id.compareTo(b.id);
      _cat..sort(_compare);
    } catch (e) {
      isCatsUpdated = false;
      print("Errr:${e}");
    }
    return _cat;
  }

  Future<List<Categories>> updateCategoryData(List<Categories> ls) async {
    // if(ls.isNotEmpty){
    try {
      await catsCache.delete();
      await catsCache.insertList(ls);
    } catch (e) {
      print(e);
    }

    if (!isCatsUpdated) {
      _latestCatsData.clear();
      for (var v in ls) {
        _latestCatsData.add(v);
      }
      isCatsUpdated = true;
      // print("Updated:${ls.length}/${_latestCatsData.length}");
    }
    // }

    return latestCatsData;
  }

  Future<List<Categories>> _catsCache() async {
    List<Categories> chech = [];
    final List<Categories> _cache = await catsCache.get();

    print("LoadedCacheU:${chech.length}");
    // _cache.rem
    return _cache;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////

}

class QuestionReposit with ChangeNotifier {
  QeustionCache qCache = QeustionCache();

  bool _isCatsUpdated = false;
  set isCatsUpdated(bool b) {
    _isCatsUpdated = b;
  }

  bool get isCatsUpdated => _isCatsUpdated;

  int _currentId;
  set currentId(int i) {
    _currentId = i;
  }

  int get currentId => _currentId;

  String _language;
  set language(String s) {
    _language = s;
  }

  String get language => _language;

  List<Questions> _latestData = [];
  UnmodifiableListView<Questions> get latestData =>
      UnmodifiableListView(_latestData);

  final Connectivity cnctvty = Connectivity();

  Stream<List<Questions>> controllor() async* {
    final List<Questions> _cacheData = await _getCache();
    if (_cacheData.isNotEmpty) {
      yield _cacheData;
    }

    ConnectivityResult result = ConnectivityResult.none;

    try {
      result = await cnctvty.checkConnectivity();
      print("Connection:$result");
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        final List<Questions> _getData = await fetchData(id: currentId);
        final List<Questions> _updateData = await updateData(_getData);
        if (_updateData.isNotEmpty) {
          print("updatedIsLive1:${_updateData.length}");
          yield _updateData;
        }
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
    // final List<Categories> _get
  }

  Future fetchData({id}) async {
    String url = 'https://bestkrok.help/api/questionByCategory/$currentId}';
    final response = await http.get(Uri.parse(url));
    List<Questions> _cat = List<Questions>.from(
        json.decode(response.body).map((x) => Questions.fromJson(x)));
    Comparator<Questions> _compare = (a, b) => a.id.compareTo(b.id);
    _cat..sort(_compare);
    print("Got Rec: ${_cat.length}/$id");
    return _cat;
  }

  Future<void> reload() async {
    final res = await cnctvty.checkConnectivity();
    if (res == ConnectivityResult.mobile || res == ConnectivityResult.wifi) {
      final _fetching = await fetchData(id: currentId);
      final _updating = await updateData(_fetching);

      Future.microtask(() => notifyListeners);
      print("updated");
    }
  }

  Future<List<Questions>> updateData(List<Questions> dataLs) async {
    try {
      qCache.insertList(dataLs);
    } catch (e) {
      print(e);
    }
    if (dataLs.isNotEmpty) {
      await _latestData.clear();

      for (var i in dataLs) {
        _latestData.add(i);
      }
    }
    return dataLs;
  }

  Future<List<Questions>> _getCache() async {
    List<Questions> tmpList = [];
    final List<Questions> _cache = await qCache.get();
    _cache.forEach((element) {
      element.id == currentId ? tmpList.add(element) : null;
    });

    print("LoadedCache:${tmpList.length}");
    // _cache.rem
    return tmpList;
  }
}
