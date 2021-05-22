import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:bestkrok_easykrok/models/question_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mlkit_translate/mlkit_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import 'all_repository.dart';
import 'package:bestkrok_easykrok/services/localbase.dart';
import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final catsManager = ChangeNotifierProvider<CatsManager>((ref)=>CatsManager());
final questcatsManager = ChangeNotifierProvider<QuestionCatsManager>((ref)=>QuestionCatsManager());


class CatsManager with ChangeNotifier{


  CatsCache catsCache = CatsCache();
  Comparator<Categories> _compare = (a, b) => a.id.compareTo(b.id);

  List<Categories> _updatedLs =[];
  UnmodifiableListView<Categories> get updatedLs  => UnmodifiableListView(_updatedLs..sort(_compare));

  List <Categories> _cachedList = [];
  UnmodifiableListView<Categories> get cachedLs => UnmodifiableListView(_cachedList..sort(_compare));

String _language ; // en,fr,ru
String get language => _language;
set language (String s){language = s;}


Future langUpdate()async{
  // try{
  //   print("hasdfalsdf-1");
  //   final _getData = await getCategoryData();
  //   final _trnslate = await transLs(_getData);
  //   // catsCache.
  //   final _updateData = await updateData(_trnslate);
  //   print("hasdfalsdf-2${_updateData.length}");
  // }catch(e){print("hasdfalsdf-3${e}");}
  // notifyListeners();
  try {
    // print("flag:1");
    ConnectivityResult result = ConnectivityResult.none;
    result = await _connectivity.checkConnectivity();
    print("Connention:$result");

    if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
// print("asdfasd");
      final _getData = await getCategoryData();
      print("_getData:${_getData.length}");
      final _trnslate = await transLs(_getData);
      print("_trnslate:${_trnslate.length}");
      // if(_trnslate.isNotEmpty){await catsCache.del();}

      final _updateData = await updateData(_trnslate);
      print("updatedLs:${updatedLs.length}");
      _currentLs = updatedLs;
      // _currentLs = _updateData;
      //
      Future.delayed(Duration(seconds: 3),notifyListeners);
    }else{
      print("no Internet");
    }

  } on PlatformException catch (e) {
    print(e.toString());
  }
//   try{
//     // _connectivitySubscription.
//
//     _connectivitySubscription =
//         _connectivity.checkConnectivity().onConnectivityChanged.listen((result)async {
//           if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
// // print("asdfasd");
//             final _getData = await getCategoryData();
//             final _trnslate = await transLs(_getData);
//             if(_trnslate.isNotEmpty){await catsCache.del();}
//
//             final _updateData = await updateData(_trnslate);
//             _currentLs = updatedLs;
//             // _currentLs = _updateData;
//             //
//             Future.delayed(Duration(seconds: 3),notifyListeners);
//           }else{
//             print("no Internet");
//           }
//
//         });
//   }catch(e){print(e);}
}
// Future update

bool _isConnected = false;
bool get isConnected => _isConnected;
set isConnected(bool b){_isConnected = b;}

  final Connectivity _connectivity = Connectivity();
   StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return Future.value(null);
    // }

    // return _updateConnectionStatus(result);
  }
  bool _lsLoaded = false;
  bool get lsLoaded => _lsLoaded;
  set lsLoaded (bool b){lsLoaded = b;}

  List<Categories> _currentLs = [];
  UnmodifiableListView<Categories> get currentLs => UnmodifiableListView(_currentLs);
  Stream <List<Categories>> dmFun()async*{
   try {
      List<Categories> _cache = await getCache();
      _currentLs = [];
      if (_cache.isNotEmpty) {
        _currentLs = _cache;
        yield _currentLs;
      }
    }catch(e){print(e);}
   await initConnectivity();

   try{
     _connectivitySubscription =
         _connectivity.onConnectivityChanged.listen((result)async {
           if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
             final _getData = await getCategoryData();
             final _trnslate = await transLs(_getData);
             // if(_trnslate.isNotEmpty){await catsCache.del();}

             final _updateData = await updateData(_trnslate);
             _currentLs = updatedLs;
             // _currentLs = _updateData;
             //
             Future.delayed(Duration(seconds: 3),notifyListeners);
           }else{
             print("no Internet");
           }

         });
   }catch(e){print(e);}





    // if(_updateData.isNotEmpty){
    //   yield _updateData;
    // }
  }


  Future  <String> getLanguage()async{
    try{
      final SharedPreferences _shrPref = await SharedPreferences.getInstance();
      _language = _shrPref.getString('language') ?? 'en';
      language = _shrPref.getString('language') ?? 'en';
    }catch(e){print(e);}
    return _language;
  }
  Future getCategoryData()async{
    String url = 'https://bestkrok.help/api/categories';
    final response = await http.get(Uri.parse(url));
    List<Categories> _cat =
    List<Categories>.from(json.decode(response.body).map((x) => Categories.fromJson(x)));
    Comparator<Categories> _compare = (a, b) => a.id.compareTo(b.id);
    _cat..sort(_compare);
    return _cat;
  }
  Future<List<Categories>> getCache()async{

    final List <Categories> _localLs = await catsCache.get();
    _cachedList.clear();
    _localLs.forEach((element) async => _cachedList.add(element));
    var uniqueProducts = _cachedList.toSet().toList();
    return cachedLs;
  }
  Future <void> addLocal(Categories ob)async{
    bool _isExist;
    List<Categories> _localList = await catsCache.get();

    try{
      var abc = _localList.firstWhere((element) {
        if(ob.id == element.id){
          _isExist = true;
          return true;

        }else{
          _isExist = false;
          return false;
        }
      },orElse:() {
        // print("or else");
        _isExist = false;
        // return element;
      }).id ?? ob.id;
      // print("${abc}");
    }catch(e){
      _isExist = false;
    }





    // bool _exist = await checkdb(ob.id);

    if(_isExist){
      // print("Exist:${ob.id},${ob.name}");
    }else{
      // print("Not Exist:${ob.id},${ob.name}");
      try{catsCache.insert(ob);}catch(e){print(e);}
    }





  }
  Future<List<Categories>> transLs(List<Categories> ls)async{
    List<Categories> _transLs = [];
    final _language = await getLanguage();
    for(var tx in ls){
      final _transTxt = await transtxt(txt: tx.name,lng: _language);
      // final String fasdf = _transTxt;
      final _trnSnap =  Categories(id: tx.id,name:_transTxt ,createdAt: tx.createdAt,updatedAt: tx.updatedAt);
      _transLs.add(_trnSnap);
    }
    return _transLs;
  }
  Future<String> transtxt({txt, lng})async{
    final _translatedTxt = await MlkitTranslate.translateText(source: 'en',   text: txt,   target: lng,);
    return _translatedTxt;
  }
  Future <List<Categories>> updateData(List<Categories> ls)async{
    _updatedLs.clear();
    for (var item in ls){
      _updatedLs.add(item);
      addLocal(item);
    }
    return _updatedLs;

  }

}


class QuestionCatsManager with ChangeNotifier{


  QeustionCache questionCatsCache = QeustionCache();
  Comparator<Questions> _compare = (a, b) => a.id.compareTo(b.id);

  List<Questions> _updatedLs =[];
  UnmodifiableListView<Questions> get updatedLs  => UnmodifiableListView(_updatedLs..sort(_compare));

  List <Questions> _cachedList = [];
  UnmodifiableListView<Questions> get cachedLs => UnmodifiableListView(_cachedList..sort(_compare));

  String _language ; // en,fr,ru
  String get language => _language;
  set language (String s){language = s;}

  int _currentCats;
  int get currentCats => _currentCats;
  set currentCats(int i){_currentCats = i;}

  String _connectionStatus = 'Unknown';
  bool _listeningInternet = false;
  bool get listeningInternet =>_listeningInternet;
  set listeningInternet (bool b){_listeningInternet = b;}

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
   initConvit()async{
     await initConnectivity();
     // _connectivitySubscription =
     //     _connectivity.onConnectivityChanged.listen(dataCRUD);
     //
     // listeningInternet = true;

   }
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return Future.value(null);
    // }

    return dataCRUD(result);
  }

  Future<List<Questions>> dataCRUD(ConnectivityResult result) async {

    if(result == ConnectivityResult.wifi){
      final _getData = await getCategoryData(id: currentCats);
      final _trnslate = await transLs(_getData);

      // if(_trnslate.isNotEmpty){await questionCatsCache.del(currentCats);}
      print("UpdatedList:a:${_trnslate.length}");
      final _updateData = await updateData(_trnslate);

      return _updateData;
    }else if(result == ConnectivityResult.mobile){
      final _getData = await getCategoryData(id: currentCats);
      final _trnslate = await transLs(_getData);

      // if(_trnslate.isNotEmpty){await questionCatsCache.del(currentCats);}

      final _updateData = await updateData(_trnslate);
      return _updateData;
    }else{

    }
  }
    // switch (result) {
    //   case ConnectivityResult.wifi:{}break;
    //   case ConnectivityResult.mobile:
    //   case ConnectivityResult.none:
    //     // setState(() => _connectionStatus = result.toString());
    //     break;
    //   default:
    //     // setState(() => _connectionStatus = 'Failed to get connectivity.');
    //     break;
    // }

Future clearCache()async{
  ConnectivityResult result = ConnectivityResult.none;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    result = await _connectivity.checkConnectivity();
    if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi ){
      final _getData = await getCategoryData(id: currentCats);
      final _trnslate = await transLs(_getData);
      if(_trnslate.isNotEmpty)await questionCatsCache.delete();
      final _updateData = await updateData(_trnslate);
      _currentDataList =updatedLs;
      Future.delayed(Duration(seconds: 2),notifyListeners);
    }else{
      print("no Internet");
      throw "No Internet";
    }


  } on PlatformException catch (e) {
    print(e.toString());
  }
 // try{
 //   final _getData = await getCategoryData(id: currentCats);
 // final _trnslate = await transLs(_getData);
 // if(_trnslate.isNotEmpty)await questionCatsCache.delete();
 // final _updateData = await updateData(_trnslate);
 // notifyListeners();
 // }catch(e){print(e);}
}
List<Questions> _currentDataList=[];
UnmodifiableListView<Questions> get currentDataList => UnmodifiableListView(_currentDataList);
Future onInitState(id)async{
  currentCats = id;
  ConnectivityResult _result =  ConnectivityResult.none;
  _result = await _connectivity.checkConnectivity();
  if(_result == ConnectivityResult.mobile || _result == ConnectivityResult.wifi){
    final _dataCrud = await dataCRUD(_result);
    if(_dataCrud.isNotEmpty){
      print("NoIntern:3}:${_dataCrud.length}");
      _currentDataList = _dataCrud;
      Future.delayed(Duration(seconds: 2), notifyListeners);
    }
  }else{
    print("No Internet");
  }
}
  Stream <List<Questions>> dmFun({id})async*{

   try{
     print("cacheList:id:${id.length}");
     currentCats = id;
     List<Questions>  _cache = await getCache(id: id);
     _currentDataList = _cache;
     if(_currentDataList.isNotEmpty){
       print("cacheList:${_currentDataList.length}");
       yield currentDataList;  }
   }catch(e){print("errorFetchingCache$e");}

   try{
     print("cachelist2:${_currentDataList.length}");
     ConnectivityResult _result =  ConnectivityResult.none;
     _result = await _connectivity.checkConnectivity();
     if(_result == ConnectivityResult.mobile || _result == ConnectivityResult.wifi){
       final _dataCrud = await dataCRUD(_result);
       if(_dataCrud.isNotEmpty){
         print("NoIntern:3}:${_dataCrud.length}");
         _currentDataList = _dataCrud;
        // Future.delayed(Duration(seconds: 2), notifyListeners);
       }
     }else{
       print("No Internet");
     }
     // if(!listeningInternet){
     //   initConvit();
     // }
     yield currentDataList;
     // print("updatedlist;asdfasd;${_currentDataList.length}");
   }catch(e){print(e);}

   /*try{
      print("NoIntern:1");
     _connectivitySubscription =
     _connectivity.onConnectivityChanged.listen((result) async{
       print("NoIntern:${result}");
       if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
         final _dataCrud = await dataCRUD(result);
         if(_dataCrud.isNotEmpty){
           print("NoIntern:3}");
           _currentDataList = _dataCrud;
           notifyListeners();
         }
       }else{
         print("No Internet");
       }



     });
// final _updateData = await dataCRUD();
//      if(_updateData.isNotEmpty){
//        yield _updateData;
//      }
   }catch(e){print(e);}*/
  }


  Future  <String> getLanguage()async{
    try{
      final SharedPreferences _shrPref = await SharedPreferences.getInstance();
      _language = _shrPref.getString('language') ?? 'en';
      language = _shrPref.getString('language') ?? 'en';
    }catch(e){print(e);}
    return _language;
  }

  Future getCategoryData({id})async{
    String url = 'https://bestkrok.help/api/questionByCategory/${id}';
    final response = await http.get(Uri.parse(url));
    List<Questions> _cat =
    List<Questions>.from(json.decode(response.body).map((x) => Questions.fromJson(x)));
    Comparator<Questions> _compare = (a, b) => a.id.compareTo(b.id);
    _cat..sort(_compare);
    return _cat;
  }

  Future<List<Questions>> getCache({id})async{

    final List <Questions> _localLs = await questionCatsCache.get();
    _cachedList.clear();
    _localLs.forEach((element) async {

      if(element.categoryId == id){
        _cachedList.add(element);
      }
    });
    var uniqueProducts = _cachedList.toSet().toList();
    return uniqueProducts;
  }
  Future <void> addLocal(Questions ob)async{
    bool _isExist;
    List<Questions> _localList = await questionCatsCache.get();

    try{
      var abc = _localList.firstWhere((element) {
        if(ob.id == element.id && ob.categoryId == element.categoryId){
          _isExist = true;
          return true;

        }else{
          _isExist = false;
          return false;
        }
      },orElse:() {
        // print("or else");
        _isExist = false;
        // return element;
      }).id ?? ob.id;
      // print("${abc}");
    }catch(e){
      _isExist = false;
    }





    // bool _exist = await checkdb(ob.id);

    if(_isExist){
      // print("Exist:${ob.id},${ob.categoryId}");
    }else{
      // print("Not Exist:${ob.id},${ob.categoryId}");
      questionCatsCache.insert(ob).then((value) => print("Added:${value}/${ob.id},/${ob.categoryId}"));
    }





  }
  Future<List<Questions>> transLs(List<Questions> ls)async{
    var _splidId = '//-//';
    List<Questions> _transLs = [];
    final _language = await getLanguage();
    int _i = 0;
    for(var tx in ls){
     try{
       final _mergTxt = "${tx.question}${_splidId}${tx.question}";
       print("translate1:$_i-old-${_mergTxt}");
       final _transTxt = await transtxt(txt: _mergTxt,lng: _language);
       print("translate1:$_i-new-${_mergTxt}");
       _i++;
       final String _ques = _transTxt.split(_splidId).first;
       final String _ansr = _transTxt.split(_splidId).last;
       final _trnSnap =  Questions(id: tx.id,question: _ques,answer: _ansr ,categoryId: tx.categoryId,createdAt: tx.createdAt,updatedAt: tx.updatedAt);
       _transLs.add(_trnSnap);
     }catch(e){print(e);}
     print("translate1:ln-${_transLs.length}");
    }
    return _transLs;
  }
  Future<String> transtxt({txt, lng})async{
    final _translatedTxt = await MlkitTranslate.translateText(source: 'en',   text: txt,   target: lng,);
    return _translatedTxt;
  }
  Future <List<Questions>> updateData(List<Questions> ls)async{
    _updatedLs.clear();
    await questionCatsCache.openDb();
    for (var item in ls){
      try{
        _updatedLs.add(item);
        addLocal(item);
      }catch(e){print("errr:$e");}
    }
    print("UpdatedList:b:${_updatedLs.length}");
    return _updatedLs;

  }
  //////////////////////////////////////////

bool _isDataLoaded = false;
bool get isDataLoaded => _isDataLoaded;
set isDataLoaded(bool b){_isDataLoaded = b;}


}