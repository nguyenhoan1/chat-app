import 'dart:convert';

class DummyItem {
  static final List<String> values = [
    id,
    name,
  ];

  static const String id = 'id';
  static const String name = 'name';
}

DummyModel dummyModelFromJson(String str) =>
    DummyModel.fromJson(json.decode(str));

String DummyModelToJson(DummyModel data) => json.encode(data.toJson());

class DummyModel {
  final int id;
  final String name;

  DummyModel({
    required this.id,
    required this.name,
  });

  DummyModel copy({int? id, String? name}) =>
      DummyModel(id: id ?? this.id, name: name ?? this.name);

  factory DummyModel.fromJson(Map<String, dynamic> json) => DummyModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
