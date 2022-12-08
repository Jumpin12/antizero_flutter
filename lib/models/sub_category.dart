import 'package:json_annotation/json_annotation.dart';

part 'sub_category.g.dart';

@JsonSerializable()
class SubCategory {
  String catName;
  String catId;
  DateTime createdAt;
  String id;
  String img;
  String name;

  SubCategory(
      {this.catName, this.catId, this.createdAt, this.id, this.img, this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);

  Map<dynamic, dynamic> toJson() => _$SubCategoryToJson(this);
}
