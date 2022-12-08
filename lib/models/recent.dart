import 'package:json_annotation/json_annotation.dart';

part 'recent.g.dart';

@JsonSerializable()
class RecentMsg {
  String recentMsg;
  String sender;
  DateTime time;

  RecentMsg({this.recentMsg, this.sender, this.time});

  factory RecentMsg.fromJson(Map<String, dynamic> json) =>
      _$RecentMsgFromJson(json);

  Map<dynamic, dynamic> toJson() => _$RecentMsgToJson(this);
}
