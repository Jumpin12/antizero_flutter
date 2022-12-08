// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'college.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

College _$CollegeFromJson(Map<String, dynamic> json) {
  return College(
    collegeName: json['collegeName'] as String,
    id: json['id'] as String
  );
}

Map<String, dynamic> _$CollegeToJson(College instance) => <String, dynamic>{
  'collegeName': instance.collegeName,
  'id': instance.id
};
