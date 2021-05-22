import 'package:bestkrok_easykrok/repository/data_controller.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String language = 'English';


  Future<void> updateApp() async {

    final reloadC = context.read(dataController);
    // reloadC.

    reloadC.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset.zero,
                  blurRadius: 5,
                  spreadRadius: 3)
            ]),
        child: ListTile(
          leading: Icon(
            Icons.language,
            color: Colors.green[500],
            size: 40,
          ),
          title: Text('Language'),
          subtitle: StreamBuilder<SharedPreferences>(
                  stream: SharedPreferences.getInstance().asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var _language = snapshot.data.get('language');
                      if (_language == 'russian') {
                        language = 'Russian';
                        return Text('Russian');
                      } else if (_language == 'fr') {
                        language = 'French';
                        return Text('French');
                      } else {
                        language = 'English';
                        return Text('English');
                      }
                    } else {
                      return Text('Loading...');
                    }
                  }) ??
              Text('Loading...'),
          onTap: () {
            print('a');
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(' Change Language'),
                    content: Container(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            child: Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: Colors.green[500],
                                    value: 'English',
                                    groupValue: language,
                                    onChanged: (val) async {
                                      setLanguage(language: 'english');
                                      language = val;
                                      await updateApp();
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    }),
                                Text(
                                  'English',
                                  style: TextStyle(fontSize: 24),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 150,
                            child: Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: Colors.green[500],
                                    value: 'Russian',
                                    groupValue: language,
                                    onChanged: (val) async {
                                      setLanguage(language: 'russian');
                                      language = val;
                                      await updateApp();
                                      setState(() {

                                        Navigator.pop(context);
                                      });
                                    }),
                                Text(
                                  'Russian',
                                  style: TextStyle(fontSize: 24),
                                )
                              ],
                            ),
                          ),
                          /* Container(
                            width: 150,
                            child: Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: Colors.green[500],
                                    value: 'French',
                                    groupValue: language,
                                    onChanged: (val) {
                                      language = val;
                                      setLanguage(language: 'fr');
                                      setState(() {
                                        final _reloadCats    =   context.read(catsManager);
                                        final _reloadQuestion = context.read(questcatsManager);

                                        _reloadCats.langUpdate();
                                        _reloadQuestion.clearCache();
                                        Navigator.pop(context);
                                      });
                                    }),
                                Text(
                                  'French',
                                  style: TextStyle(fontSize: 24),
                                )
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Future<void> setLanguage({language}) async {
    try {
      final SharedPreferences _shPref = await SharedPreferences.getInstance();
      _shPref.setString('language', language);
    } catch (e) {
      print(e);
    }
  }
}
