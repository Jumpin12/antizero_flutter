import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/category.dart';
import 'package:antizero_jumpin/models/college.dart';
import 'package:antizero_jumpin/models/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:antizero_jumpin/models/sub_category.dart';

class CollegeService {
  var collegeRef = FirebaseFirestore.instance.collection('college');

  // fetch interest
  Future<List<College>> getCollege() async {
    print('getCollege');
    List<College> publicCollege = [];
    try {
      print('snap');
      var snap = await collegeRef.where('id', isNull: false).get();
      print('snap length ${snap.docs.length}');
      if (snap.docs.length > 0)
      {
        for (int i = 0; i < snap.docs.length; i++)
        {
          College college = College.fromJson(snap.docs[i].data());
          publicCollege.add(college);
        }
        return publicCollege;
      }
      else {
        return null;
      }
    } catch (e) {
      print('Error : ${e.toString()}');
      return null;
    }
  }
}
