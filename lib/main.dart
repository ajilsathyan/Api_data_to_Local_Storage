import 'package:bestkrok_easykrok/screens/all_category_screen.dart';
import 'package:bestkrok_easykrok/screens/all_questions.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

// void main() {
//   runApp(const ProviderScope(child: MyApp()));
//
//
//
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[500],
          textTheme: TextTheme(headline1: TextStyle(color: Colors.white)),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
