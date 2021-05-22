import 'dart:async';
import 'package:bestkrok_easykrok/database/db_provider.dart';
import 'package:bestkrok_easykrok/models/category_model.dart';
import 'package:bestkrok_easykrok/repository/all_repository.dart';
import 'package:bestkrok_easykrok/screens/all_questions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {


  Repository repository = Repository();
  List<Categories> list;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();

    getLanguage();
    Timer(Duration(seconds: 2), () {
      loadCategory();
    });
  }

  String language = 'english';
  getLanguage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String getLanguage = _prefs.getString('language');

    if (getLanguage == null) {
      setState(() {});
    }
    if (getLanguage != null) {
      setState(() {
        language = getLanguage;
      });
    }
  }

  loadCategory() {
    var english = language == 'english';
    var russian = language == 'russian';
    if (english) {
      setState(() {
        isLoading = false;
      });
      return DBProvider.db.getAllEnglishCategory().asStream();
    }
    if (russian) {
      setState(() {
        isLoading = false;
      });
      return DBProvider.db.getAllRussianCategory().asStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    Repository _services = Repository();

    print(language);
    return Scaffold(
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(0), child: Container()),
      body: StreamBuilder(
        stream: loadCategory(),
        builder: (context, snapshot) {
          try {
            print(snapshot.data.length);
          } catch (e) {
            print(e);
          }
          if (snapshot.hasData) {
            return ListView.separated(
              // itemCount: snapshot.data.length,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                // Categories categories = Categories();
                // // categories = snapshot.data[index];
                // categories = snapshot.data[index];
                return ListTile(
                  onTap: () {
                    // setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllQuestionScreen(
                                title: '${snapshot.data[index].name}',
                                id: snapshot.data[index].id)));
                    // });
                  },
                  // title: Text('${categories.name}'),
                  title: Text('${snapshot.data[index].name}'),
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                );
              },
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[500]),
            ));
          }
        },
      ),
    );
  }
}
