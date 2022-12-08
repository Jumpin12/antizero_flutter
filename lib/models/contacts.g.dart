// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserContact _$UserContactFromJson(Map<String, dynamic> json) {
  return UserContact(
    name: json['name'] as String,
    number: json['number'] as String,
  );
}

Map<String, dynamic> _$UserContactToJson(UserContact instance) =>
    <String, dynamic>{
      'name': instance.name,
      'number': instance.number,
    };
