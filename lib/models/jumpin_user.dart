import 'package:antizero_jumpin/models/company.dart';
import 'package:antizero_jumpin/models/contacts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jumpin_user.g.dart';

@JsonSerializable()
class JumpInUser {
  String id;
  String name;
  String gender;
  String username;
  DateTime dob;
  DateTime createdAt;
  String profession;
  String placeOfWork;
  String placeOfEdu;
  String academicCourse;
  String bio;
  String email;
  String inJumpInFor;
  Map<String, dynamic> geoPoint;
  List<String> interestList;
  List<String> photoList;
  String audio;
  List<UserContact> contacts;
  List<String> connection;
  List<String> plans;
  String phoneNo;
  String searchUname;
  Map<String, dynamic> favourites;
  @JsonKey(defaultValue: 0)
  int unseenTotalCount;
  bool isOnline;
  String geohash;
  Map<String, dynamic> location;
  @JsonKey(defaultValue: 0)
  int mode;
  @JsonKey(defaultValue: 0)
  int deactivate;

  JumpInUser({
    this.id,
    this.name,
    this.gender,
    this.username,
    this.dob,
    this.createdAt,
    this.profession,
    this.placeOfWork,
    this.placeOfEdu,
    this.academicCourse,
    this.bio,
    this.email,
    this.inJumpInFor,
    this.geoPoint,
    this.interestList,
    this.photoList,
    this.audio,
    this.contacts,
    this.connection,
    this.plans,
    this.phoneNo,
    this.searchUname,
    this.favourites,
    this.unseenTotalCount,
    this.isOnline,
    this.geohash,
    this.location,
    this.mode,
    this.deactivate
  });

  factory JumpInUser.fromJson(Map<String, dynamic> json) =>
      _$JumpInUserFromJson(json);

  Map<dynamic, dynamic> toJson() => _$JumpInUserToJson(this);
}
