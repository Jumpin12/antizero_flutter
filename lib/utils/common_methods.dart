import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/filter.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

formatTime(DateTime fetchedDateTime) {
  DateTime currentDateTime = DateTime.now();
  if (fetchedDateTime != null &&
      currentDateTime.year == fetchedDateTime.year &&
      currentDateTime.month == fetchedDateTime.month &&
      currentDateTime.day - fetchedDateTime.day == 0) {
    return timeago.format(fetchedDateTime);
  } else {
    return Jiffy(fetchedDateTime ?? DateTime.now()).yMMMd;
  }
}

List getCompanyOrCollegeNameFromMode(BuildContext context)
{
  print('getCompanyNameFromMode');
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  int mode = Provider.of<ModeProvider>(context, listen: false).getCurrentMode;
  JumpInUser currentUser = userProvider.currentUser;
  String companyName = '';
  if(currentUser.mode==0)
  {
    // 0 for no mode and ' ' is companyName
    return [0,''];
  }
  else
  {
    print('companyName ${userProvider.currentUser.placeOfWork}');
    String companyName = userProvider.currentUser.placeOfWork;
    String collegeName = userProvider.currentUser.placeOfEdu;
    print('mode,name ${mode} , ${companyName}');
    if(companyName !=null && companyName.length >0)
      // 1 for company and ' ' is companyName
      return [1,companyName];
    else if(collegeName !=null && collegeName.length >0)
      // 2 for college and ' ' is companyName
      return [2,collegeName];
    else
      return [0,''];
  }
}

Future<JumpInUser> getCurrentMode() async {
  await locator.get<UserService>().getCurrentUser();
}