import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

class Company {
  String companyName;
  String id;
  String passCode;

  Company({this.companyName, this.id, this.passCode});

  Company.named(
      {this.companyName,
        this.id,
        this.passCode});

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<dynamic, dynamic> toJson() => _$CompanyToJson(this);
}
