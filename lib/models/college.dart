import 'package:json_annotation/json_annotation.dart';

part 'college.g.dart';

class College {
  String collegeName;
  String id;

  College({this.collegeName, this.id});

  College.named(
      {this.collegeName,
        this.id});

  factory College.fromJson(Map<String, dynamic> json) =>
      _$CollegeFromJson(json);

  Map<dynamic, dynamic> toJson() => _$CollegeToJson(this);
}
