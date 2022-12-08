import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  String categoryName;
  DateTime createdAt;
  String id;
  String img;

  Category({this.categoryName, this.createdAt, this.id, this.img});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<dynamic, dynamic> toJson() => _$CategoryToJson(this);
}
