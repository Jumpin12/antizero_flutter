import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class BookMark {
  String userId;
  String id;
  List<String> peopleMark;
  List<String> planMark;

  BookMark({this.userId, this.id, this.peopleMark, this.planMark});

  factory BookMark.fromJson(Map<String, dynamic> json) =>
      _$BookMarkFromJson(json);

  Map<dynamic, dynamic> toJson() => _$BookMarkToJson(this);
}
