// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookMark _$BookMarkFromJson(Map<String, dynamic> json) {
  return BookMark(
    userId: json['userId'] as String,
    id: json['id'] as String,
    peopleMark:
        (json['peopleMark'] as List<dynamic>).map((e) => e as String).toList(),
    planMark:
        (json['planMark'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$BookMarkToJson(BookMark instance) => <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'peopleMark': instance.peopleMark,
      'planMark': instance.planMark,
    };
