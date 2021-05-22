import 'dart:async';
import 'dart:io';

import 'package:bestkrok_easykrok/database/db_provider.dart';
import 'package:bestkrok_easykrok/database/qb_db_provider.dart';
import 'package:bestkrok_easykrok/models/question_model.dart';
import 'package:bestkrok_easykrok/repository/all_repository.dart';
import 'package:bestkrok_easykrok/widget/simple_question_wiget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AllQuestionScreen extends StatefulWidget {
  final String title;
  final int id;

  const AllQuestionScreen({this.title, this.id});

  @override
  _AllQuestionScreenState createState() => _AllQuestionScreenState();
}

class _AllQuestionScreenState extends State<AllQuestionScreen> {
  Repository _services = Repository();
  List<Questions> questionsList;

  bool isloading = true;
  bool isConnected;
  StreamSubscription sub;
  @override
  void initState() {
    getQuestionsData();

    super.initState();
  }

//await _services.fetchQuestionsByCategory(widget.id);
  getQuestionsData() async {
    // await _services.fetchQuestionsByCategory(widget.id);
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      await _services.fetchQuestionsByCategory(widget.id);
      var questionsById =
          await QuestionDbProvider.db.getQuestionById(widget.id);
      setState(() {
        questionsList = questionsById;
        isloading = false;
      });
      print('You Have Internet');
    } else {
      print('No internet :( Reason:');
      print(InternetConnectionChecker().lastTryResults);
      var questionsById =
          await QuestionDbProvider.db.getQuestionById(widget.id);
      setState(() {
        questionsList = questionsById;
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Text(widget.title),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[500])),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: questionsList.length,
              itemBuilder: (context, index) {
                Questions questions = Questions();
                questions = questionsList[index];
                // print(questions.id);
                print(questions.question.toString());
                print(questions.lang.length);
                return QuestionWidget(
                  question: questions.question,
                  answer: questions.answer,
                );
              },
            ),
    );
  }
}
