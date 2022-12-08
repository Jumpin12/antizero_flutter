// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) {
  return SubCategory(
    catName: json['catName'] as String,
    catId: json['catId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    id: json['id'] as String,
    img: json['img'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{
      'catName': instance.catName,
      'catId': instance.catId,
      'createdAt': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'img': instance.img,
      'name': instance.name,
    };
