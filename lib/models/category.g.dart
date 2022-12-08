// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    categoryName: json['categoryName'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    id: json['id'] as String,
    img: json['img'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'categoryName': instance.categoryName,
      'createdAt': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'img': instance.img,
    };
