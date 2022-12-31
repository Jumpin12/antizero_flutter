import 'package:json_annotation/json_annotation.dart';

part 'college.g.dart';

class College {
  String collegeName;
  String id;
  String passCode;

  College({this.collegeName, this.id,this.passCode});

  College.named(
      {this.collegeName,
        this.id,
        this.passCode});

  factory College.fromJson(Map<String, dynamic> json) =>
      _$CollegeFromJson(json);

  Map<dynamic, dynamic> toJson() => _$CollegeToJson(this);
}
