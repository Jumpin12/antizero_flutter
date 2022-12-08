import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:antizero_jumpin/models/sub_category.dart';

class InterestService {
  var catRef = FirebaseFirestore.instance.collection('category');
  var subCatRef = FirebaseFirestore.instance.collection('subCategory');

  // fetch interest
  Future<List<String>> getInterestCategory() async {
    List<String> catList = [];
    try {
      var doc = await catRef.orderBy('createdAt', descending: true).get();
      doc.docs.forEach((element) {
        catList.add(element['categoryName']);
      });
      return catList;
    } catch (e) {
      showToast(e.toString());
      return null;
    }
  }

  // fetch interest category by name
  Future<Category> getInterestCategoryByName(String catName) async {
    try {
      var doc = await catRef.where('categoryName', isEqualTo: catName).get();
      if (doc.docs.length > 0) {
        Category category = Category.fromJson(doc.docs[0].data());
        return category;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // fetch interest sub category by id
  Future<SubCategory> getInterestSubCategoryById(String id) async {
    try {
      var doc = await subCatRef.doc(id).get();
      if (doc.exists) {
        SubCategory subCategory = SubCategory.fromJson(doc.data());
        return subCategory;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // fetch subcategory
  Future<List<String>> getSubCategoryNameById(List<String> name) async {
    List<String> subCatList = [];
    var subDoc =
        await subCatRef.where('name', whereIn: name).get().catchError((e) {
      showToast(e.toString());
    });
    for (int i = 0; i < subDoc.docs.length; i++) {
      var subCat = SubCategory.fromJson(subDoc.docs[i].data());
      subCatList.add(subCat.id);
    }
    return subCatList;
  }

  // fetch subcategory
  Future<List<SubCategory>> getInterestSubCategory(String cat) async {
    List<SubCategory> subCatList = [];
    var subDoc =
        await subCatRef.where('catName', isEqualTo: cat).get().catchError((e) {
      showToast(e.toString());
    });
    for (int i = 0; i < subDoc.docs.length; i++) {
      var subCat = SubCategory.fromJson(subDoc.docs[i].data());
      subCatList.add(subCat);
    }
    return subCatList;
  }

  Future<List<SubCategory>> getSearchInterestSubCategory(String subcat) async {
    List<SubCategory> subCatList = [];
    print('getSearchInterestSubCategory $subcat');
    var subDoc =
    await subCatRef.where('name', isEqualTo: subcat).get().catchError((e) {
      showToast(e.toString());
    });
    for (int i = 0; i < subDoc.docs.length; i++) {
      var subCat = SubCategory.fromJson(subDoc.docs[i].data());
      subCatList.add(subCat);
      print('subCatList ${subCat.id} ${subCat.name}');
    }
    return subCatList;
  }

  // fetch interest list of user
  Future<List<SubCategory>> getUserInterests(List<String> interestList) async {
    List<SubCategory> subIntList = [];
    try {
      for (int i = 0; i < interestList.length; i++) {
        var subDoc = await subCatRef.doc(interestList[i]).get();
        SubCategory sub = SubCategory.fromJson(subDoc.data());
        subIntList.add(sub);
      }
      return subIntList;
    } catch (e) {
      showToast('Error in fetching interest list');
      print(e);
      return null;
    }
  }
}
