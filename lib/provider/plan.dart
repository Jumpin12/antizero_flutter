import 'dart:collection';

import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:flutter/material.dart';

class PlanProvider with ChangeNotifier {
  Plan _currentPlan;
  JumpInUser _currentPlanHost;
  // List<String> _currentPlanUsers = [];
  String _searchText;
  bool loading = false;
  bool _hasMore = true;
  bool _isFirstListLoading = false;
  bool _isNextListLoading = false;
  bool _acceptingPlan = false;
  int _defaultPlansPerPageCount = 5;
  List<Plan> _planList = [];
  Plan _lastPlan;
  bool _noPlans = false;

  Plan get currentPlan => _currentPlan;
  JumpInUser get currentPlanHost => _currentPlanHost;
  // List<String> get currentPlanUsers => _currentPlanUsers;
  List<Plan> get planList => _planList;
  String get searchText => _searchText;
  bool get acceptingPlan => _acceptingPlan;
  bool get isFirstListLoading => _isFirstListLoading;
  bool get isNextListLoading => _isNextListLoading;
  bool get noPlans => _noPlans;

  set currentPlan(Plan plan) {
    _currentPlan = plan;
    notifyListeners();
  }

  set currentPlanHost(JumpInUser host) {
    _currentPlanHost = host;
    notifyListeners();
  }

  setFirstListLoading(bool val) {
    _isFirstListLoading = val;
    notifyListeners();
  }

  setNextListLoading(bool val) {
    _isNextListLoading = val;
    notifyListeners();
  }

  setHasMore(bool val) {
    _hasMore = true;
    notifyListeners();
  }

  setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  set planList(List<Plan> list) {
    _planList = list;
    notifyListeners();
  }

  addPlansToList(List<Plan> list) {
    _planList.addAll(list);
    notifyListeners();
  }

  // set currentPlanUsers(List<String> users) {
  //   _currentPlanUsers = users;
  //   notifyListeners();
  // }

  setAcceptingPlan(bool status) {
    _acceptingPlan = status;
    notifyListeners();
  }

  setNoPlans(bool val) {
    _noPlans = val;
    notifyListeners();
  }

  Future<void> getHomePlan(BuildContext context) async {
    loading = true;
    notifyListeners();
    _planList = await locator.get<PlanService>().fetchCurrentUserHomePlan(context);
    loading = false;
    notifyListeners();
  }

  fetchSearchPlans(BuildContext context) async {
    _hasMore = true;
    setFirstListLoading(true);
    _planList = await locator.get<PlanService>().getSearchPlansFirst(
        limit: _defaultPlansPerPageCount, query: searchText);
    setFirstListLoading(false);

    for (var i = 0; i < _planList.length; i++) {
      if (checkStatus(_planList[i].member, context) == MemberStatus.Accepted) {
        _planList.remove(_planList[i]);
      }
    }

    if (_planList != null && planList.isNotEmpty) {
      setNoPlans(false);
      if (_planList.length < _defaultPlansPerPageCount) {
        _hasMore = false;
      }

      _lastPlan = _planList[_planList.length - 1];

      if (_planList.length >= _defaultPlansPerPageCount) {
        _planList.removeLast();
      }

      notifyListeners();
    } else {
      setNoPlans(true);
    }
  }

  fetchPlans(BuildContext context) async {
    List<Plan> tempPlanList = [];
    if (!_hasMore) {
      print('No More Plans');
      return;
    }
    if (_lastPlan != null && _planList.length == 0) {
      setNoPlans(true);
      return;
    }
    if (_isFirstListLoading || _isNextListLoading) {
      return;
    }

    if (_lastPlan == null) {
      setFirstListLoading(true);
      tempPlanList = await locator
          .get<PlanService>()
          .getPublicPlan(context,limit: _defaultPlansPerPageCount);
      setFirstListLoading(false);
    } else {
      setNextListLoading(true);
      if (searchText != null && searchText.isNotEmpty) {
        tempPlanList = await locator.get<PlanService>().getSearchPlansNext(
            previousUser: _lastPlan.searchPname,
            query: searchText,
            limit: _defaultPlansPerPageCount);
      } else {
        tempPlanList = await locator.get<PlanService>().getNextPlan(context,
            date: _lastPlan.createdAt.toIso8601String(),
            limit: _defaultPlansPerPageCount);
      }
      setNextListLoading(false);
    }

    if (tempPlanList != null && tempPlanList.isNotEmpty) {
      setNoPlans(false);
      if (tempPlanList.length < _defaultPlansPerPageCount) {
        _hasMore = false;
      }

      _lastPlan = tempPlanList[tempPlanList.length - 1];

      if (searchText != null &&
          searchText.isNotEmpty &&
          tempPlanList.length >= _defaultPlansPerPageCount) {
        tempPlanList.removeLast();
      }
    } else {
      if(tempPlanList!=null)
        {
          if (tempPlanList.isEmpty) setNoPlans(true);
        }
       else
         {
           setNoPlans(true);
         }
    }

    if(tempPlanList!=null)
    addPlansToList(tempPlanList);
  }

  checkIfListEnoughForScroll(
      BuildContext context, PlanProvider planProvider) async {
    int availableCount = 0;
    if (planProvider.planList.isNotEmpty) {
      planProvider.planList.forEach((element) {
        MemberStatus status = checkStatus(element.member, context);
        if (status == MemberStatus.Accepted) {
          availableCount += 1;
        }
      });
      if (availableCount >= 3) {
        await planProvider.fetchPlans(context);
      }
    }
  }

  setDefaults() {
    _planList = [];
    _searchText = null;
    _hasMore = true;
    _lastPlan = null;
    notifyListeners();
  }
}
