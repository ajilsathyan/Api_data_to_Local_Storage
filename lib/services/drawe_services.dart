import 'package:bestkrok_easykrok/screens/all_category_screen.dart';
import 'package:bestkrok_easykrok/screens/language_screen.dart';
import 'package:bestkrok_easykrok/screens/main_screen.dart';
import 'package:flutter/material.dart';

class DrawerServices {
  Widget drawerservices(title) {
    if (title == 'Best Krok MCQs App') {
      return CategoryScreen();
    }
    if (title == 'All Categories') {
      return CategoryScreen();
    }
    if (title == 'Language') {
      return LanguageScreen();
    }
    if (title == 'More Apps') {
      return CategoryScreen();
    }
    if (title == 'Share Your Friend') {
      return CategoryScreen();
    }
    if (title == 'Rate Us') {
      return CategoryScreen();
    }
    if (title == 'Feedback') {
      return CategoryScreen();
    }
  }
}
