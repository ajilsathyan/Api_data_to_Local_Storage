import 'dart:convert';

List<Questions> questionsFromJson(String str) =>
    List<Questions>.from(json.decode(str).map((x) => Questions.fromJson(x)));

String questionsToJson(List<Questions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Questions {
  Questions({
    this.id,
    this.question,
    this.answer,
    this.categoryId,
    this.lang,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String question;
  String answer;
  int categoryId;
  String lang;
  DateTime createdAt;
  DateTime updatedAt;

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        categoryId: json["category_id"],
        lang: json["lang"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "category_id": categoryId,
        "lang": lang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  Map<String, dynamic> toMap() =>
     {
       "id": id,
       "question": question,
       "answer": answer,
       "category_id": categoryId,
       "lang": lang,
       "created_at": createdAt.toIso8601String(),
       "updated_at": updatedAt.toIso8601String(),
    };

}




