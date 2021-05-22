import 'dart:convert';

List<Russian> russianFromJson(String str) =>
    List<Russian>.from(json.decode(str).map((x) => Russian.fromJson(x)));

String russianToJson(List<Russian> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Russian {
  Russian({
    this.id,
    this.name,
    this.lang,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String lang;
  DateTime createdAt;
  DateTime updatedAt;

  factory Russian.fromJson(Map<String, dynamic> json) => Russian(
        id: json["id"],
        name: json["name"],
        lang: json["lang"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lang": lang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "lang": lang,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}
