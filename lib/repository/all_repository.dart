import 'package:bestkrok_easykrok/database/db_provider.dart';
import 'package:bestkrok_easykrok/database/qb_db_provider.dart';
import 'package:bestkrok_easykrok/models/category_model.dart';
import 'package:bestkrok_easykrok/models/english_modal.dart';
import 'package:bestkrok_easykrok/models/question_model.dart';
import 'package:bestkrok_easykrok/models/russian_modal.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;

class Repository {
  Future<List<Categories>> fetchCategoriesData() async {
    String url = 'https://bestkrok.help/api/categories';
    Response response = await Dio().get(url);
    return (response.data as List).map((category) {
      //You can check the data from url is Inserting to the dbTable or not
      //print("Inserting $category");
      DBProvider.db.createCategoryDataBase(Categories.fromJson(category));
    }).toList();
  }

  // english
  Future<List<English1>> fetchEnglishLanguage() async {
    String url1 = 'https://bestkrok.help/api/getCategoryByLanguage/english';
    Response response1 = await Dio().get(url1);
    return (response1.data as List).map((language) {
      //You can check the data from url is Inserting to the dbTable or not
      // print("Inserting based on English language $language");
      DBProvider.db.createCategoryEnglish(English1.fromJson(language));
    }).toList();
  }

  Future<List<Russian>> fetchRussianLanguage() async {
    String url = 'https://bestkrok.help/api/getCategoryByLanguage/russian';
    Response response = await Dio().get(url);
    return (response.data as List).map((language) {
      //You can check the data from url is Inserting to the dbTable or not
      //print("Inserting based on Russian language $language");
      DBProvider.db.createCategoryRussian(Russian.fromJson(language));
    }).toList();
  }

  ///
  Future<List<Questions>> fetchQuestionsByCategory(id) async {
    String url = 'https://bestkrok.help/api/questionByCategory/$id';
    Response response = await Dio().get(url);
    return (response.data as List).map((language) {
      //You can check the data from url is Inserting to the dbTable or not
      print("Inserting based id $language");
      QuestionDbProvider.db
          .createCategoryQuestions(Questions.fromJson(language));
    }).toList();
  }

  Future<List<Questions>> fetchQuestionsData() async {
    String url = 'https://bestkrok.help/api/questions';
    final response = await http.get(Uri.parse(url));
    return questionsFromJson(response.body);
  }
}
