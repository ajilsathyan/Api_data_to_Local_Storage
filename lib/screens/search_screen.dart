import 'package:bestkrok_easykrok/widget/food_item_list.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<FoodItem> list = [
    FoodItem(
        title:
            'in non odio excepturi sint eum\nlabore voluptates vitae quia qui et\ninventore itaque rerum\nveniam non exercitationem delectus aut',
        category: 'quaerat velit veniam amet cupiditate aut numquam ut sequi'),
    FoodItem(
        title:
            'eum non blanditiis soluta porro quibusdam voluptas\nvel voluptatem qui placeat dolores qui velit aut\nvel inventore aut cumque culpa explicabo aliquid at\nperspiciatis est et voluptatem dignissimos dolor itaque sit nam',
        category: 'quas fugiat ut perspiciatis vero provident'),
    FoodItem(
        title:
            'eum non blanditiis soluta porro quibusdam voluptas\nvel voluptatem qui placeat dolores qui velit aut\nvel inventore aut cumque culpa explicabo aliquid at\nperspiciatis est et voluptatem dignissimos dolor itaque sit nam"',
        category: 'Fruit'),
    FoodItem(
        title:
            'doloremque ex facilis sit sint culpa\nsoluta assumenda eligendi non ut eius\nsequi ducimus vel quasi\nveritatis est dolores',
        category: 'Vegetables'),
    FoodItem(
        title:
            'quo deleniti praesentium dicta non quod\naut est molestias\nmolestias et officia quis nihil\nitaque dolorem quia',
        category: 'Vegetables'),
    FoodItem(
        title:
            'cupiditate quo est a modi nesciunt soluta\nipsa voluptas error itaque dicta in\nautem qui minus magnam et distinctio eum\naccusamus ratione error aut',
        category: 'Men'),
    FoodItem(
        title:
            'ex quod dolorem ea eum iure qui provident amet\nquia qui facere excepturi et repudiandae\nasperiores molestias provident\nminus incidunt vero fugit rerum sint sunt excepturi provident',
        category: 'Woman'),
    FoodItem(
        title:
            'ut libero sit aut totam inventore sunt\nporro sint qui sunt molestiae\nconsequatur cupiditate qui iste ducimus adipisci\ndolor enim assumenda soluta laboriosam amet iste delectus hic',
        category: 'children'),
    FoodItem(
        title:
            'est molestiae facilis quis tempora numquam nihil qui\nvoluptate sapiente consequatur est qui\nnecessitatibus autem aut ipsa aperiam modi dolore numquam\nreprehenderit eius rem quibusdam',
        category: 'Fruit'),
    FoodItem(title: 'Pear', category: 'Fruit'),
    FoodItem(title: 'Gauva', category: 'Fruit'),
  ];
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   FoodItemSearch();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Text('Search'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchPage<FoodItem>(
                    barTheme: Theme.of(context).copyWith(
                      backgroundColor: Colors.green[500],
                      textTheme: TextTheme(
                        headline1: TextStyle(color: Colors.white),
                        headline2: TextStyle(color: Colors.white),
                        headline3: TextStyle(color: Colors.white),
                        headline4: TextStyle(color: Colors.white),
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                    ),
                    onQueryUpdate: (s) => print(s),
                    items: list,
                    searchLabel: 'Search here',
                    suggestion: Center(
                      child: Text('Filter by category'),
                    ),
                    failure: Center(
                      child: Text('No FoodItems found :('),
                    ),
                    filter: (list) => [
                      list.category,
                      list.title,
                    ],
                    builder: (list) => Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(list.title),
                        subtitle: Text(list.category),
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final FoodItem foodItem = list[index];
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(foodItem.title),
              subtitle: Text(foodItem.category),
            ),
          );
        },
      ),
    );
  }
}
