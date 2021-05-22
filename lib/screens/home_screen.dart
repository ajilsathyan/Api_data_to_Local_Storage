import 'package:bestkrok_easykrok/repository/all_repository.dart';
import 'package:bestkrok_easykrok/screens/search_screen.dart';
import 'package:bestkrok_easykrok/services/drawe_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import '../menu_widget.dart';

class HomeScreen extends StatefulWidget {
  final String language;
  HomeScreen({this.language});
  @override
  _HomeScreenState createState() => _HomeScreenState();
  static const String id = 'home-screen';
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  String title;
  DrawerServices _services = DrawerServices();

  Repository repository = Repository();

  @override
  void initState() {
    repository.fetchRussianLanguage();
    repository.fetchEnglishLanguage();
    title = "Best Krok MCQs App";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SliderMenuContainer(
            appBarColor: Colors.green[500],
            key: _key,
            sliderMenuOpenSize: 200,
            appBarHeight: 80,
            drawerIconColor: Colors.white,
            trailing: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SearchScreen();
                }));
              },
              icon: Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            sliderMenu: MenuWidget(
              onItemClick: (title) {
                _key.currentState.closeDrawer();
                setState(() {
                  this.title = title;
                });
              },
            ),
            sliderMain: _services.drawerservices(title)),
      ),
    );
  }
}
