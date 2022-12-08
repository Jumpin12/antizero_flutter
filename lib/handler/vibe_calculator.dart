// import 'package:antizero_jumpin/handler/profile.dart';
// import 'package:antizero_jumpin/handler/user.dart';
// import 'package:antizero_jumpin/models/jumpin_user.dart';
// import 'package:antizero_jumpin/models/plan.dart';
// import 'package:antizero_jumpin/models/sub_category.dart';
// import 'package:antizero_jumpin/provider/user.dart';
// import 'package:antizero_jumpin/services/interest.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
//
// import '../main.dart';
//
// Future<double> calculateVibe(
//     JumpInUser userWithCompare, BuildContext context) async {
//   int distanceCount;
//   int interestCount;
//   int ageDiffCount;
//   int workCount;
//   int studyCount;
//   double total = 50;
//   JumpInUser currentUser =
//       Provider.of<UserProvider>(context, listen: false).currentUser;
//   if (currentUser != null) {
//     distanceCount = await calDistCount(currentUser, userWithCompare);
//     interestCount = calInterestCount(currentUser, userWithCompare);
//     ageDiffCount = calAgeDifferenceCount(currentUser, userWithCompare);
//     workCount = calWorkCount(currentUser, userWithCompare);
//     studyCount = calStudyCount(currentUser, userWithCompare);
//   }
//   total = distanceCount.toDouble() +
//       interestCount.toDouble() +
//       ageDiffCount.toDouble() +
//       workCount.toDouble() +
//       studyCount.toDouble();
//   return total;
// }
//
// Future<int> calDistCount(
//     JumpInUser currentUser, JumpInUser userWithCompare) async {
//   if (currentUser.geoPoint != null && userWithCompare.geoPoint != null) {
//     double distanceInMeters = Geolocator.distanceBetween(
//         currentUser.geoPoint['Lat'],
//         currentUser.geoPoint['Long'],
//         userWithCompare.geoPoint['Lat'],
//         userWithCompare.geoPoint['Long']);
//     double distanceInKm = distanceInMeters / 1000;
//     if (distanceInKm < 2) {
//       return 10;
//     } else if (distanceInKm > 2 && distanceInKm < 5) {
//       return 9;
//     } else if (distanceInKm > 5 && distanceInKm < 10) {
//       return 8;
//     } else if (distanceInKm > 10 && distanceInKm < 15) {
//       return 7;
//     } else if (distanceInKm > 15) {
//       return 6;
//     } else {
//       return 6;
//     }
//   } else {
//     return 6;
//   }
// }
//
// int calInterestCount(JumpInUser currentUser, JumpInUser userWithCompare) {
//   List<String> comparingUserInterest = userWithCompare.interestList;
//   int commonInterestLength = 0;
//   for (int i = 0; i < currentUser.interestList.length; i++) {
//     if (comparingUserInterest.contains(currentUser.interestList[i])) {
//       commonInterestLength = commonInterestLength++;
//     }
//   }
//   if (commonInterestLength > 5) {
//     return 30;
//   } else if (commonInterestLength == 4) {
//     return 28;
//   } else if (commonInterestLength == 3) {
//     return 26;
//   } else if (commonInterestLength == 2) {
//     return 24;
//   } else if (commonInterestLength == 1) {
//     return 22;
//   } else {
//     return 20;
//   }
// }
//
// calAgeDifferenceCount(JumpInUser currentUser, JumpInUser userWithCompare) {
//   int firstAge = getAgeFromDob(currentUser.dob);
//   int secondAge = getAgeFromDob(currentUser.dob);
//   int difference;
//   if (firstAge > secondAge) {
//     difference = firstAge - secondAge;
//   } else {
//     difference = secondAge - firstAge;
//   }
//   if (difference > 5) {
//     return 10;
//   } else if (difference == 4) {
//     return 12;
//   } else if (difference == 3) {
//     return 14;
//   } else if (difference == 2) {
//     return 16;
//   } else if (difference == 1) {
//     return 18;
//   } else {
//     return 20;
//   }
// }
//
// int calWorkCount(JumpInUser currentUser, JumpInUser userWithCompare) {
//   if (currentUser.placeOfWork != null && userWithCompare.placeOfWork != null) {
//     if (currentUser.placeOfWork == userWithCompare.placeOfWork) {
//       return 10;
//     } else {
//       return 8;
//     }
//   } else {
//     return 8;
//   }
// }
//
// int calStudyCount(JumpInUser currentUser, JumpInUser userWithCompare) {
//   if (currentUser.placeOfEdu != null && userWithCompare.placeOfEdu != null) {
//     if (currentUser.placeOfEdu == userWithCompare.placeOfEdu) {
//       return 10;
//     } else {
//       return 8;
//     }
//   } else {
//     return 8;
//   }
// }
//
// Future<double> calculatePlanVibe(Plan plan, BuildContext context) async {
//   int distanceCount;
//   int categoryCount;
//   int mutualCount;
//   int similarCount = 8;
//   int recommendCount = 15;
//   double total = 50;
//   JumpInUser currentUser =
//       Provider.of<UserProvider>(context, listen: false).currentUser;
//   if (currentUser != null) {
//     if (plan.online == true) {
//       distanceCount = 20;
//     } else {
//       distanceCount = await calPlanDistCount(currentUser, plan);
//     }
//     categoryCount = await calCategoryCount(currentUser, plan.catName);
//     mutualCount = await calMutualCount(currentUser, plan, context);
//   }
//   total = distanceCount.toDouble() +
//       categoryCount.toDouble() +
//       mutualCount.toDouble() +
//       similarCount.toDouble() +
//       recommendCount.toDouble();
//   return total;
// }
//
// Future<int> calCategoryCount(JumpInUser currentUser, String catName) async {
//   for (int i = 0; i < currentUser.interestList.length; i++) {
//     SubCategory subCategory = await locator
//         .get<InterestService>()
//         .getInterestSubCategoryById(currentUser.interestList[i]);
//     if (subCategory != null) {
//       if (subCategory.catName == catName) {
//         return 30;
//       }
//     } else {
//       return 20;
//     }
//   }
//   return 20;
// }
//
// Future<int> calPlanDistCount(JumpInUser currentUser, Plan currentPlan) async {
//   if (currentUser.geoPoint != null && currentPlan.geoLocation != null) {
//     double distanceInMeters = Geolocator.distanceBetween(
//         currentUser.geoPoint['Lat'],
//         currentUser.geoPoint['Long'],
//         currentPlan.geoLocation['Lat'],
//         currentPlan.geoLocation['Long']);
//     double distanceInKm = distanceInMeters / 1000;
//     if (distanceInKm < 2) {
//       return 20;
//     } else if (distanceInKm > 2 && distanceInKm < 5) {
//       return 18;
//     } else if (distanceInKm > 5 && distanceInKm < 10) {
//       return 16;
//     } else if (distanceInKm > 10 && distanceInKm < 15) {
//       return 14;
//     } else if (distanceInKm > 15) {
//       return 12;
//     } else {
//       return 12;
//     }
//   } else {
//     return 12;
//   }
// }
//
// Future<int> calMutualCount(
//     JumpInUser currentUser, Plan currentPlan, BuildContext context) async {
//   int connectionCount = 0;
//   for (int i = 0; i < currentPlan.userIds.length; i++) {
//     bool connected = await checkIfInConnection(context, currentPlan.userIds[i]);
//     if (connected) {
//       connectionCount = connectionCount + 1;
//     }
//   }
//   if (connectionCount > 20) {
//     return 10;
//   } else if (connectionCount > 12 && connectionCount < 16) {
//     return 9;
//   } else if (connectionCount > 8 && connectionCount < 12) {
//     return 8;
//   } else if (connectionCount > 4 && connectionCount < 8) {
//     return 7;
//   } else if (connectionCount > 0 && connectionCount < 4) {
//     return 6;
//   } else {
//     return 5;
//   }
// }
