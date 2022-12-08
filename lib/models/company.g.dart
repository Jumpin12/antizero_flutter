// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return Company(
    companyName: json['companyName'] as String,
    id: json['id'] as String,
    passCode: json['passCode'] as String,
  );
}

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'companyName': instance.companyName,
  'id': instance.id,
  'passCode': instance.passCode,
};
