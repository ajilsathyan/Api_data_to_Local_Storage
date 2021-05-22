
import 'package:bestkrok_easykrok/repository/all_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'adddnewproduct - screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Repository _repository = Repository();
  @override
  void initState() {
    getLanguage();
    _repository.fetchCategoriesData();
    _repository.fetchEnglishLanguage();
    _repository.fetchRussianLanguage();
    super.initState();
  }

  String language;
  Future<void> getLanguage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String getLanguage = _prefs.getString('language');
    setState(() {
      language = getLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Text('main Screen'),
    ));
  }
}
