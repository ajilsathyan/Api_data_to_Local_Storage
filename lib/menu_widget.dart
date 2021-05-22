import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 40,),
          SizedBox(
          width: 150,
            height: 100,
            child: Image.asset('images/logo.png',fit: BoxFit.fill,),
          ),
          // CircleAvatar(
          //
          //   backgroundImage: AssetImage('images/logo.png'),
          //
          // ),
          SizedBox(
            height: 30,
          ),
          Text(
            'BestKrok-EasyKrok',
            style: TextStyle(
              color: Colors.green[600],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          sliderItem('All Categories',  Icons.category,),
          sliderItem('Language', Icons.language),
          sliderItem('More Apps', Icons.apps),
          sliderItem('Share Your Friend', Icons.share),
          sliderItem('Rate Us', Icons.thumb_up),

          sliderItem('Feedback', Icons.help)
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) {

    return ListTile(
      minVerticalPadding: 0,
        horizontalTitleGap: 0,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.green[600],
          ),
        ),
        leading: Icon(
          icons,
          color: Colors.green[600],
        ),
        onTap: () {
          onItemClick(title);
        });
  }
}
