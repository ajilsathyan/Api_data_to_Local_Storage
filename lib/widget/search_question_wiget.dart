import 'package:bestkrok_easykrok/widget/food_item_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchQuestionWidget extends StatelessWidget {
  final List<TextSpan> title;
  final String category;

  const SearchQuestionWidget({this.title, this.category});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, offset: Offset.zero, blurRadius: 5)
          ]),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.green[500],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.white), children: title),
            ),
            // 'The dialog route created by this method is pushed to the root navigator.'
            // ' If the application has multiple Navigator objects, it may be necessary to cal',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: Text(
              this.category,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
