import 'package:json_annotation/json_annotation.dart';

part 'contacts.g.dart';

@JsonSerializable()
class UserContact {
  String name;
  String number;

  UserContact({this.name, this.number});

  factory UserContact.fromJson(Map<String, dynamic> json) =>
      _$UserContactFromJson(json);

  Map<dynamic, dynamic> toJson() => _$UserContactToJson(this);
}
