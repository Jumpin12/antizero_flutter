import 'package:json_annotation/json_annotation.dart';

part 'connection.g.dart';

@JsonSerializable()
class Connection {
  String requestedTo;
  String status;
  DateTime createdAt;

  Connection({this.requestedTo, this.status, this.createdAt});

  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ConnectionToJson(this);
}
