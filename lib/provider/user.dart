import 'package:antizero_jumpin/handler/profile.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:flutter/material.dart';

enum LocationType {
  SearchWithinState,
  SearchWithinCountry,
  SearchOutsideCountry,
  SearchAnywhere,
}

enum GenderFilter { Male, Female, Others, None }

enum OrderFilter { Random, Ordered }

class UserProvider with ChangeNotifier {
  JumpInUser _currentUser;
  JumpInUser _chatWithUser;
  FriendRequest _currentPeopleGroup;
  String _searchText;
  bool _hasMore = true;
  bool _isFirstListLoading = false;
  bool _isNextListLoading = false;
  int _defaultUsersPerPageCount = 5;
  List<JumpInUser> _userEmailList = [];
  List<JumpInUser> _userList = [];
  List<JumpInUser> _userSearchList = [];
  JumpInUser _lastUser;
  JumpInUser _lastFilteredUser;
  JumpInUser _lastSearchUser;
  bool _noUsers = false;
  int _unseenMsgCount = 0;
  String _userState;
  String _userCountry;
  LocationType _locationType;
  RangeValues _ageRangeValues;
  RangeValues _distanceRangeValues;
  GenderFilter _genderFilter;
  OrderFilter _orderFilter;
  List<String> _selectedInterests;
  List<SubCategory> _presetselectedInterests;
  List<JumpInUser> malConnnections = [];
  // List _distanceFilter;
  bool _filtersEnabled = false;

  JumpInUser get currentUser => _currentUser;

  JumpInUser get chatWithUser => _chatWithUser;

  FriendRequest get currentPeopleGroup => _currentPeopleGroup;

  List<JumpInUser> get usersList => _userList;

  String get searchText => _searchText;

  bool get isFirstListLoading => _isFirstListLoading;

  bool get isNextListLoading => _isNextListLoading;

  bool get noUsers => _noUsers;

  int get unseenMsgCount => _unseenMsgCount;

  String get userState => _userState;

  String get userCountry => _userCountry;

  RangeValues get ageRangeValues => _ageRangeValues;

  RangeValues get distanceRangeValues => _distanceRangeValues;

  GenderFilter get getGenderFilter => _genderFilter;

  OrderFilter get getOrderFilter => _orderFilter;

  List<String> get getSelectedInterests => _selectedInterests;

  List<SubCategory> get getpresetselectedInterests => _presetselectedInterests;

  // List get distanceFilter => _distanceFilter;
  List<JumpInUser> get getConnections => malConnnections;

  LocationType get getLocation => _locationType;

  bool get filtersEnabled => _filtersEnabled;

  set currentUser(JumpInUser user) {
    _currentUser = user;
    notifyListeners();
  }

  set chatWithUser(JumpInUser user) {
    _chatWithUser = user;
    notifyListeners();
  }

  set currentPeopleGroup(FriendRequest currentPeople) {
    _currentPeopleGroup = currentPeople;
    notifyListeners();
  }

  setSearchText(String text) {
    _searchText = text;
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

  setAgeRangeValues(RangeValues values) {
    _ageRangeValues = values;
    notifyListeners();
  }

  setDistanceRangeValues(RangeValues values) {
    _distanceRangeValues = values;
    notifyListeners();
  }

  setGenderFilter(GenderFilter val) {
    _genderFilter = val;
    notifyListeners();
  }

  setOrderFilter(OrderFilter val) {
    _orderFilter = val;
    notifyListeners();
  }

  setSelectedInterets(List<String> selected) {
    _selectedInterests = selected;
    notifyListeners();
  }

  setPresetSelectedInterets(List<SubCategory> presetselected) {
    _presetselectedInterests = presetselected;
    notifyListeners();
  }

  setConnections(JumpInUser connections) {
    malConnnections.add(connections);
    notifyListeners();
  }

  // setDistanceFilter(List val) {
  //   _distanceFilter = val;
  //   notifyListeners();
  // }

  setFiltersEnabled(bool val) {
    _filtersEnabled = val;
    notifyListeners();
  }

  set usersList(List<JumpInUser> list) {
    _userList = list;
  }

  addUsersToList(List<JumpInUser> list) {
    _userList.addAll(list);
    notifyListeners();
  }

  addSearchUsersToList(List<JumpInUser> list) {
    _userList.addAll(list);
    notifyListeners();
  }

  filterUsersToList(List<JumpInUser> list) {
    _userList.addAll(list);
    notifyListeners();
  }

  resetLastUserSearch(JumpInUser val) {
    _lastSearchUser = null;
    notifyListeners();
  }

  resetConnectionSearch() {
    malConnnections = null;
    notifyListeners();
  }

  setNoUsers(bool val) {
    _noUsers = val;
    notifyListeners();
  }

  setUnseenMsgCount(int val) {
    _unseenMsgCount = val;
    notifyListeners();
  }

  fetchSearchUsers() async
  {
    print('fetchSearchUsers');
    // _hasMore = true;
    // setFirstListLoading(true);
    // _userList = await locator.get<UserService>().getSearchUsersFirst(limit: _defaultUsersPerPageCount, query: searchText);
    // setFirstListLoading(false);
    // if (_userList != null && usersList.isNotEmpty) {
    //   setNoUsers(false);
    //   if (_userList.length < _defaultUsersPerPageCount) {
    //     _hasMore = false;
    //   }
    //
    //   _lastUser = _userList[_userList.length - 1];
    //
    //   if (_userList.length >= _defaultUsersPerPageCount) {
    //     _userList.removeLast();
    //   }
    //   notifyListeners();
    // } else {
    //   setNoUsers(true);
    // }
    // if (!_hasMore) {
    //   print('No More Users');
    //   return;
    // }
    // if ((_isFirstListLoading || _isNextListLoading)) {
    //   return;
    // }

    // print('_lastUser ${_lastUser}');
    // print('Location Type ${_locationType}');
    // if (_lastSearchUser == null) {
    //   setFirstListLoading(true);
    //   _userSearchList =await locator.get<UserService>().getSearchUsersFirst(limit: _defaultUsersPerPageCount,query: searchText);
    //   setFirstListLoading(false);
    // } else {
    //   setNextListLoading(true);
    //   print('_lastSearchUser ${_lastSearchUser.username}');
    //   _userSearchList = await locator.get<UserService>().getSearchUsersNext(
    //       previousUser: _lastSearchUser.username,
    //       query: searchText,
    //       limit: _defaultUsersPerPageCount);
    //   setNextListLoading(false);
    // }
    //
    // if (_userSearchList != null && _userSearchList.isNotEmpty) {
    //   setNoUsers(false);
    //   if (_userSearchList.length < _defaultUsersPerPageCount) {
    //     _lastSearchUser = null;
    //     _hasMore = false;
    //   }
    //   else{
    //     _lastSearchUser = _userSearchList[_userSearchList.length - 1];
    //     _hasMore = true;
    //     if (_userSearchList.length >= _defaultUsersPerPageCount) {
    //       _userSearchList.removeLast();
    //     }
    //   }
    // } else {
    //   _lastSearchUser = null;
    //     if (_userSearchList.isEmpty) setNoUsers(true);
    // }
    //
    // addSearchUsersToList(_userSearchList ?? []);
  }

  // fetchFilteredUsers(BuildContext context) async {
  //   print('fetchFilteredUsers _hasMore $_hasMore');
  //   if (!_hasMore) {
  //     print('No More Users');
  //     return;
  //   }
  //   print(_lastFilteredUser);
  //   print(_locationType);
  //   if (_lastFilteredUser == null) {
  //     if (_locationType == LocationType.SearchWithinState)
  //       setFirstListLoading(true);
  //     else
  //       setNextListLoading(true);
  //
  //     _userList = await locator.get<UserService>().getFilteredUsersT(context,
  //         limit: _defaultUsersPerPageCount, locationType: _locationType);
  //     print(_userList.length);
  //     if (_locationType == LocationType.SearchWithinState)
  //       setFirstListLoading(false);
  //     else
  //       setNextListLoading(false);
  //   } else {
  //     setNextListLoading(true);
  //     print('_lastFilteredUser.name ${_lastFilteredUser.name}');
  //     _userList = await locator.get<UserService>().getFilteredUsersNextT(
  //         context,
  //         previousUser: _lastFilteredUser,
  //         limit: _defaultUsersPerPageCount,
  //         locationType: _locationType);
  //     print(_userList.length);
  //     setNextListLoading(false);
  //   }
  //
  //   if (_userList != null && _userList.isNotEmpty) {
  //     setNoUsers(false);
  //     if (_userList.length < _defaultUsersPerPageCount) {
  //       if (_locationType == LocationType.SearchWithinState) {
  //         _locationType = LocationType.SearchWithinCountry;
  //         _lastFilteredUser = null;
  //       } else if (_locationType == LocationType.SearchWithinCountry) {
  //         _locationType = LocationType.SearchOutsideCountry;
  //         _lastFilteredUser = null;
  //       } else if (_locationType == LocationType.SearchOutsideCountry) {
  //         _locationType = LocationType.SearchAnywhere;
  //         _lastFilteredUser = null;
  //       } else {
  //         _hasMore = false;
  //       }
  //       _hasMore = false;
  //     } else {
  //       _hasMore = true;
  //       print('_hasMore');
  //       _lastFilteredUser = _userList[_userList.length - 1];
  //     }
  //   } else {
  //     if (_locationType == LocationType.SearchWithinState) {
  //       _locationType = LocationType.SearchWithinCountry;
  //       _lastFilteredUser = null;
  //     } else if (_locationType == LocationType.SearchWithinCountry) {
  //       _locationType = LocationType.SearchOutsideCountry;
  //       _lastFilteredUser = null;
  //     } else if (_locationType == LocationType.SearchOutsideCountry) {
  //       _locationType = LocationType.SearchAnywhere;
  //       _lastFilteredUser = null;
  //     } else {}
  //     if (_userList.isEmpty) setNoUsers(true);
  //   }
  //   print(_userList);
  //   notifyListeners();
  // }

  getUserCityAndState({bool fromLocationHandler = false}) async {
    if (fromLocationHandler == false &&
        _currentUser != null &&
        _currentUser.geoPoint != null) {
      String address = await getAddressFromLatLng(
          Lat: currentUser.geoPoint['Lat'], Long: currentUser.geoPoint['Long']);
      if (address != null) {
        List<String> addressList = address.split(',');
        _userState = addressList[0].trim();
        _userCountry = addressList[1].trim();
      }
    } else {
      _userState = null;
      _userCountry = null;
    }

    print('$_userState ----> $_userCountry');
  }

  // fetchUsers(context, {bool fromLocationHandler = false}) async {
  //   print('Fetch users');
  //   List<JumpInUser> tempUsersList = [];
  //   if (!_hasMore) {
  //     print('No More Users');
  //     return;
  //   }
  //   if ((!fromLocationHandler && _isFirstListLoading || _isNextListLoading)) {
  //     return;
  //   }
  //   if (_lastUser == null) {
  //     if (_locationType == LocationType.SearchWithinState)
  //       setFirstListLoading(true);
  //     else
  //       setNextListLoading(true);
  //     tempUsersList = await locator.get<UserService>().getAllUser(context,
  //         limit: _defaultUsersPerPageCount,locationType: _locationType);
  //     if (_locationType == LocationType.SearchWithinState)
  //       setFirstListLoading(false);
  //     else
  //       setNextListLoading(false);
  //   }
  //   else {
  //     setNextListLoading(true);
  //     if (searchText != null && searchText.isNotEmpty) {
  //       tempUsersList = await locator.get<UserService>().getSearchUsersNext(
  //           previousUser: _lastUser.searchUname,
  //           query: searchText,
  //           limit: _defaultUsersPerPageCount);
  //     } else {
  //       tempUsersList = await locator.get<UserService>().getNextUser(context,
  //           lastUser: _lastUser,
  //           limit: _defaultUsersPerPageCount,
  //           locationType: _locationType);
  //     }
  //     setNextListLoading(false);
  //   }
  //   // else {
  //   //       setNextListLoading(true);
  //   //       print('print _lastUser ${_lastUser.username}');
  //   //       tempUsersList = await locator.get<UserService>().getNextUser(context,
  //   //           lastUser: _lastUser,
  //   //           limit: _defaultUsersPerPageCount);
  //   //       print('tempUsersList');
  //   //       setNextListLoading(false);
  //   // }
  //
  //   if (tempUsersList != null && tempUsersList.isNotEmpty) {
  //     setNoUsers(false);
  //     _lastUser = tempUsersList[tempUsersList.length - 1];
  //
  //     if (tempUsersList.length < _defaultUsersPerPageCount) {
  //       if (_locationType == LocationType.SearchWithinState) {
  //         _locationType = LocationType.SearchWithinCountry;
  //         _lastUser = null;
  //       } else if (_locationType == LocationType.SearchWithinCountry) {
  //         _locationType = LocationType.SearchOutsideCountry;
  //         _lastUser = null;
  //       } else if (_locationType == LocationType.SearchOutsideCountry) {
  //         _locationType = LocationType.SearchAnywhere;
  //         _lastUser = null;
  //       } else {
  //         _hasMore = true;
  //       }
  //       // _lastUser = null;
  //       // _hasMore = true;
  //     }
  //
  //     // if (searchText != null &&
  //     //     searchText.isNotEmpty &&
  //     //     tempUsersList.length >= _defaultUsersPerPageCount) {
  //     //   tempUsersList.removeLast();
  //     // }
  //     if (tempUsersList.length >= _defaultUsersPerPageCount) {
  //       tempUsersList.removeLast();
  //     }
  //   } else {
  //     if (_locationType == LocationType.SearchWithinState) {
  //       _locationType = LocationType.SearchWithinCountry;
  //       _lastUser = null;
  //     } else if (_locationType == LocationType.SearchWithinCountry) {
  //       _locationType = LocationType.SearchOutsideCountry;
  //       _lastUser = null;
  //     } else if (_locationType == LocationType.SearchOutsideCountry) {
  //       _locationType = LocationType.SearchAnywhere;
  //       _lastUser = null;
  //     } else {
  //       if (_userList.isEmpty) setNoUsers(true);
  //     }
  //     // if (_userList.isEmpty) setNoUsers(true);
  //   }
  //   print('tempUsersList ${tempUsersList.length}');
  //   addUsersToList(tempUsersList ?? []);
  // }

  fetchFilteredUsers(BuildContext context) async
  {
    print('fetchFilteredUsers _hasMore $_hasMore');
    print('_lastUser ${_lastUser}');
    print('Location Type ${_locationType}');
    List<JumpInUser> tempUsersList = [];
    if (!_hasMore) {
      print('No More Users');
      return;
    }
    if (_isFirstListLoading || _isNextListLoading) {
      return;
    }
    if (_lastUser == null)
    {
      if (_locationType == LocationType.SearchWithinState)
        setFirstListLoading(true);
      else
        setNextListLoading(true);
      tempUsersList = await locator.get<UserService>().getFilteredUsersT(context,
          limit: _defaultUsersPerPageCount, locationType: _locationType);
      print('tempUsersList ${tempUsersList.length}');

      if (_locationType == LocationType.SearchWithinState)
        setFirstListLoading(false);
      else
        setNextListLoading(false);
    }
    else
    {
      setNextListLoading(true);
      print('_lastUser ${_lastUser.username}');
      tempUsersList = await locator.get<UserService>().getFilteredUsersNextT(context,
          previousUser: _lastUser,
          limit: _defaultUsersPerPageCount,
          locationType: _locationType);
      setNextListLoading(false);
    }

    if (tempUsersList != null && tempUsersList.isNotEmpty) {
      setNoUsers(false);
      print('tempUsersList.length ${tempUsersList.length}');
      print('_defaultUsersPerPageCount ${_defaultUsersPerPageCount}');
      print('_lastUser ${_lastUser}');
      print('_hasMore ${_hasMore}');
      if (tempUsersList.length < _defaultUsersPerPageCount) {
        if (_locationType == LocationType.SearchWithinState) {
          _locationType = LocationType.SearchWithinCountry;
          _lastUser = null;
        } else if (_locationType == LocationType.SearchWithinCountry) {
          _locationType = LocationType.SearchOutsideCountry;
          _lastUser = null;
        } else if (_locationType == LocationType.SearchOutsideCountry) {
          _locationType = LocationType.SearchAnywhere;
          _lastUser = null;
        } else {
          if (_userList.isEmpty) setNoUsers(true);
        }
      }
      else{
        _lastUser = tempUsersList[tempUsersList.length - 1];
        _hasMore = true;
        if (tempUsersList.length >= _defaultUsersPerPageCount) {
          tempUsersList.removeLast();
        }
      }
    } else {
      if (_locationType == LocationType.SearchWithinState) {
        _locationType = LocationType.SearchWithinCountry;
        _lastUser = null;
      } else if (_locationType == LocationType.SearchWithinCountry) {
        _locationType = LocationType.SearchOutsideCountry;
        _lastUser = null;
      } else if (_locationType == LocationType.SearchOutsideCountry) {
        _locationType = LocationType.SearchAnywhere;
        _lastUser = null;
      } else {
        if (_userList.isEmpty) setNoUsers(true);
      }
    }
    print('_hasMore:_lastUser $_hasMore : ${_lastUser}');
    print('_locationType $_locationType');
    print(_userList);
    filterUsersToList(tempUsersList ?? []);
  }


  fetchUsers(context, {bool fromLocationHandler = false}) async {
    print('fetchUsers');
    List<JumpInUser> tempUsersList = [];
    if (!_hasMore) {
      print('No More Users');
      return;
    }
    if (!fromLocationHandler && (_isFirstListLoading || _isNextListLoading)) {
      return;
    }

    // print('_lastUser ${_lastUser}');
    // print('Location Type ${_locationType}');
    if (_lastUser == null) {
      if (_locationType == LocationType.SearchWithinState)
        setFirstListLoading(true);
      else
        setNextListLoading(true);
      tempUsersList = await locator.get<UserService>().getAllUser(context,
          limit: _defaultUsersPerPageCount, locationType: _locationType);
      if (_locationType == LocationType.SearchWithinState)
        setFirstListLoading(false);
      else
        setNextListLoading(false);
    } else {
      setNextListLoading(true);
      print('_lastUser ${_lastUser.username}');
      tempUsersList = await locator.get<UserService>().getNextUser(context,
            lastUser: _lastUser,
            limit: _defaultUsersPerPageCount,
            locationType: _locationType);
      setNextListLoading(false);
    }

    if (tempUsersList != null && tempUsersList.isNotEmpty) {
      setNoUsers(false);
      if (tempUsersList.length < _defaultUsersPerPageCount) {
        if (_locationType == LocationType.SearchWithinState) {
          _locationType = LocationType.SearchWithinCountry;
          _lastUser = null;
        } else if (_locationType == LocationType.SearchWithinCountry) {
          _locationType = LocationType.SearchOutsideCountry;
          _lastUser = null;
        } else if (_locationType == LocationType.SearchOutsideCountry) {
          _locationType = LocationType.SearchAnywhere;
          _lastUser = null;
        } else {
          _hasMore = false;
        }
      }
      else{
        _lastUser = tempUsersList[tempUsersList.length - 1];
        _hasMore = true;
        if (tempUsersList.length >= _defaultUsersPerPageCount) {
          tempUsersList.removeLast();
        }
      }
    } else {
      if (_locationType == LocationType.SearchWithinState) {
        _locationType = LocationType.SearchWithinCountry;
        _lastUser = null;
      } else if (_locationType == LocationType.SearchWithinCountry) {
        _locationType = LocationType.SearchOutsideCountry;
        _lastUser = null;
      } else if (_locationType == LocationType.SearchOutsideCountry) {
        _locationType = LocationType.SearchAnywhere;
        _lastUser = null;
      } else {
        if (_userList.isEmpty) setNoUsers(true);
      }
    }

    addUsersToList(tempUsersList ?? []);
  }

  // Future<List<JumpInUser>> fetchUserEmail(context,int limit) async
  // {
  //   List<JumpInUser> tempUsersList = [];
  //   if (_lastUser == null) {
  //     tempUsersList = await locator.get<UserService>().getAllUsersEmailAddress(context,limit);
  //   } else {
  //     print('_lastUser ${_lastUser.username}');
  //     tempUsersList = await locator.get<UserService>().getAllNextUsersEmailAddress(context,limit,_lastUser);
  //   }
  //
  //   if (tempUsersList != null && tempUsersList.isNotEmpty) {
  //     setNoUsers(false);
  //     if (tempUsersList.length < limit) {
  //         _lastUser = null;
  //         _hasMore = false;
  //       }
  //     else{
  //       _lastUser = tempUsersList[tempUsersList.length - 1];
  //       _hasMore = true;
  //       if (tempUsersList.length >= _defaultUsersPerPageCount) {
  //         tempUsersList.removeLast();
  //       }
  //     }
  //   } else {
  //     _lastUser = null;
  //     if (_userList.isEmpty) setNoUsers(true);
  //   }
  //
  //   return tempUsersList;
  // }

  Future<List<JumpInUser>> fetchUserEmail(context,int limit) async
  {
    print('fetchUserEmail');
    List<JumpInUser> tempUsersList = [];
    tempUsersList =  await locator.get<UserService>().getAllUsersEmailAddress(context,limit);
    print('fetchUserEmail $tempUsersList');
    print('fetchUserEmail length ${tempUsersList.length}');
    do
    {
      _lastUser = tempUsersList[tempUsersList.length - 1];
      print('_lastUser ${_lastUser.username}');
      print('last length ${tempUsersList.length}');
      tempUsersList.addAll(await locator.get<UserService>().getAllNextUsersEmailAddress(context,limit,_lastUser));
    }
    while(tempUsersList.length<3000);
    return tempUsersList;
  }

  firstLoading(context) async {
    await locator
        .get<UserService>()
        .getAllUser(context,
            limit: _defaultUsersPerPageCount, locationType: _locationType)
        .then((value) => addUsersToList(value));
  }

  setDefaults() {
    print('setDefaults $_filtersEnabled');
    if (_filtersEnabled) {
      _userList = [];
      _searchText = null;
      _hasMore = true;
      _lastUser = null;
      _locationType = LocationType.SearchWithinState;
      _filtersEnabled = true;
    } else {
      _userList = [];
      _searchText = null;
      _hasMore = true;
      _lastUser = null;
      _locationType = LocationType.SearchWithinState;
      _filtersEnabled = false;
    }
    notifyListeners();
  }

  setDefaultsFilter() {
    print('setDefaultsFilter $_filtersEnabled');
    _userList = [];
    _searchText = null;
    _hasMore = true;
    _lastUser = null;
    _locationType = LocationType.SearchWithinState;
    notifyListeners();
  }
}
