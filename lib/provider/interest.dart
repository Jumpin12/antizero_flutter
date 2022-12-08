import 'dart:collection';

import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/services/interest.dart';
import 'package:antizero_jumpin/utils/interest.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class InterestProvider extends ChangeNotifier {
  Map<String, bool> _categoriesMap = Map.fromIterable(Categories,
      key: (item) => item.toString(), value: (item) => false);
  Map<String, dynamic> _subCategoriesMap = SubCategories;
  String _selectedCategory = "Outdoor Sports";
  List<String> _selectedInterestList = [];

  String _currentCategory;
  List<String> _categories = [];
  List<SubCategory> _subCategories = [];
  List<SubCategory> _userInterest = [];
  List<String> _selectedSubCategories = [];
  bool loading = false;
  bool _searchEnabled = false;

  Map get getCategories => _categoriesMap;
  Map get getSubCategories => _subCategoriesMap;
  String get getSelectedCategory => _selectedCategory;
  UnmodifiableListView<String> get selectedInterestList =>
      UnmodifiableListView(_selectedInterestList);

  String get currentCategory => _currentCategory;
  UnmodifiableListView<String> get categories =>
      UnmodifiableListView(_categories);
  UnmodifiableListView<String> get selectedSubCategories =>
      UnmodifiableListView(_selectedSubCategories);
  UnmodifiableListView<SubCategory> get subCategories =>
      UnmodifiableListView(_subCategories);
  UnmodifiableListView<SubCategory> get userInterest =>
      UnmodifiableListView(_userInterest);

  set categories(List<String> catList) {
    _categories = catList;
    notifyListeners();
  }

  set subCategories(List<SubCategory> subCatList) {
    _subCategories = subCatList;
    notifyListeners();
  }

  set userInterest(List<SubCategory> subCatList) {
    _userInterest = subCatList;
    notifyListeners();
  }

  setSelectedSubCategories(List<String> selectionList, {bool init = false}) {
    _selectedSubCategories = selectionList;
    if (!init) notifyListeners();
  }

  set currentCategory(String cat) {
    _currentCategory = cat;
    notifyListeners();
  }

  Future<void> refresh(String catName) async {
    loading = true;
    notifyListeners();
    _subCategories =
        await locator.get<InterestService>().getInterestSubCategory(catName);
    loading = false;
    notifyListeners();
  }

  set setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  set selectedInterestList(List<String> interestList) {
    _selectedInterestList = interestList;
    notifyListeners();
  }

  void selectedCategory(String category) {
    _selectedCategory = category;
    _categoriesMap[category] = true;
    _subCategoriesMap.forEach((category, subCategory) {
      int count = 0;
      (subCategory as Map<String, dynamic>).forEach((key, value) {
        if (value[0] == true) {
          count += 1;
        }
      });
      if (count == 0 && _selectedCategory != category) {
        _categoriesMap[category] = false;
      }
    });
    notifyListeners();
  }

  Future<void> deSelectedCategory(
      String category, ItemScrollController _controller) async {
    _selectedCategory = category;
    _categoriesMap[category] = false;
    (_subCategoriesMap[category] as Map).values.forEach((element) {
      if (element[0] == true) {
        element[0] = false;
      }
    });
    for (var key in _categoriesMap.keys) {
      if (_categoriesMap[key] == true) {
        _selectedCategory = key;
        break;
      }
    }
    _controller.scrollTo(
        index: _categoriesMap.keys.toList().indexOf(_selectedCategory),
        duration: Duration(milliseconds: 500));
    notifyListeners();
  }

  void selectSubCategory(String subCategory) {
    if (_subCategoriesMap[_selectedCategory][subCategory][0] == false) {
      _subCategoriesMap[_selectedCategory][subCategory][0] = true;
    } else {
      _subCategoriesMap[_selectedCategory][subCategory][0] = false;
    }
    notifyListeners();
  }
}
