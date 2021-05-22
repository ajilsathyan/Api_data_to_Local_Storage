class FoodItem {
  final String title;
  final String category;

  FoodItem({this.title, this.category});
}

List<FoodItem> loadItem() {
  var fi = <FoodItem>[
    FoodItem(title: 'in non odio excepturi sint eum\nlabore voluptates vitae quia qui et\ninventore itaque rerum\nveniam non exercitationem delectus aut', category: 'quaerat velit veniam amet cupiditate aut numquam ut sequi'),
    FoodItem(title: 'eum non blanditiis soluta porro quibusdam voluptas\nvel voluptatem qui placeat dolores qui velit aut\nvel inventore aut cumque culpa explicabo aliquid at\nperspiciatis est et voluptatem dignissimos dolor itaque sit nam', category: 'quas fugiat ut perspiciatis vero provident'),
    FoodItem(title: 'eum non blanditiis soluta porro quibusdam voluptas\nvel voluptatem qui placeat dolores qui velit aut\nvel inventore aut cumque culpa explicabo aliquid at\nperspiciatis est et voluptatem dignissimos dolor itaque sit nam"', category: 'Fruit'),
    FoodItem(title: 'doloremque ex facilis sit sint culpa\nsoluta assumenda eligendi non ut eius\nsequi ducimus vel quasi\nveritatis est dolores', category: 'Vegetables'),
    FoodItem(title: 'quo deleniti praesentium dicta non quod\naut est molestias\nmolestias et officia quis nihil\nitaque dolorem quia', category: 'Vegetables'),
    FoodItem(title: 'cupiditate quo est a modi nesciunt soluta\nipsa voluptas error itaque dicta in\nautem qui minus magnam et distinctio eum\naccusamus ratione error aut', category: 'Men'),
    FoodItem(title: 'ex quod dolorem ea eum iure qui provident amet\nquia qui facere excepturi et repudiandae\nasperiores molestias provident\nminus incidunt vero fugit rerum sint sunt excepturi provident', category: 'Woman'),
    FoodItem(title: 'ut libero sit aut totam inventore sunt\nporro sint qui sunt molestiae\nconsequatur cupiditate qui iste ducimus adipisci\ndolor enim assumenda soluta laboriosam amet iste delectus hic', category: 'children'),
    FoodItem(title: 'est molestiae facilis quis tempora numquam nihil qui\nvoluptate sapiente consequatur est qui\nnecessitatibus autem aut ipsa aperiam modi dolore numquam\nreprehenderit eius rem quibusdam', category: 'Fruit'),
    FoodItem(title: 'Pear', category: 'Fruit'),
    FoodItem(title: 'Gauva', category: 'Fruit'),
  ];
  return fi;
}
