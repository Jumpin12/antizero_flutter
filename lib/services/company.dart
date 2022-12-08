import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/category.dart';
import 'package:antizero_jumpin/models/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:antizero_jumpin/models/sub_category.dart';

class CompanyService {
  var companyRef = FirebaseFirestore.instance.collection('company');

  // fetch interest
  Future<List<Company>> getCompany() async {
    print('getCompany');
    List<Company> publicCompany = [];
    try {
      print('snap');
      var snap = await companyRef.where('id', isNull: false).get();
      print('snap ${snap.docs.length}');
      if (snap.docs.length > 0)
      {
        for (int i = 0; i < snap.docs.length; i++)
        {
          Company company = Company.fromJson(snap.docs[i].data());
          publicCompany.add(company);
        }
        return publicCompany;
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
