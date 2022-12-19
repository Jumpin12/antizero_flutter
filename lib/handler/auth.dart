import 'dart:async';
import 'dart:io';

import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/auth.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/authentication/googleAuthScreen.dart';
import 'package:antizero_jumpin/screens/authentication/interest.dart';
import 'package:antizero_jumpin/screens/authentication/phone_verification.dart';
import 'package:antizero_jumpin/screens/dashboard/dashboard.dart';
import 'package:antizero_jumpin/screens/on_board/on_board.dart';
import 'package:antizero_jumpin/screens/on_board/videoplayerscreen.dart';
import 'package:antizero_jumpin/services/auth.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/interest.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:uuid/uuid.dart';

uploadCat(String name) async {
  var id = Uuid().v4();
  await FirebaseFirestore.instance.collection('category').doc(id).set({
    'categoryName': name,
    'createdAt': DateTime.now().toIso8601String(),
    'id': id,
    'img': ''
  });
}

uploadCategory(String cat) async {
  QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
      .collection('category')
      .where('categoryName', isEqualTo: cat)
      .get();
  // QuerySnapshot<Map<String, dynamic>> subDoc = await FirebaseFirestore.instance.collection('category').doc(doc.docs.first['id']).collection('subCategory').get();
  (SubCategories[cat] as Map).keys.forEach((element) async {
    var id = Uuid().v4();
    String imgPath = SubCategories[cat][element][0];

    // var docId = await FirebaseFirestore.instance.collection('subCategory').where('name', isEqualTo: element).get();
    //
    // await FirebaseFirestore.instance.collection('subCategory').doc(docId.docs[0].id).update({
    //   'img': imgPath
    // });

    await FirebaseFirestore.instance.collection('subCategory').doc(id).set({
      'catName': cat,
      'catId': doc.docs.first['id'],
      'name': element,
      'createdAt': DateTime.now().toIso8601String(),
      'id': id,
      'img': imgPath
    });

    // var subEDoc = await FirebaseFirestore.instance.collection('subCategory').where('name', isEqualTo: element).get();
    // String imgPath = SubCategories[cat][element][0];
    // await FirebaseFirestore.instance.collection('subCategory').doc(subEDoc.docs.first['id']).update({
    //   'img':
    // });
  });
  print('Done!');

  // Categories.forEach((cat) async {
  //     QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('category').where('categoryName', isEqualTo: cat).get();
  //     QuerySnapshot<Map<String, dynamic>> subDoc = await FirebaseFirestore.instance.collection('category').doc(doc.docs.first['id']).collection('subCategory').get();
  //     subDoc.docs.forEach((element) async{
  //       var name = element['name'];
  //       var imgPath = SubCategories[cat][name][1];
  //       File img = await getImageFileFromAssets(imgPath.toString());
  //       // String url = await uploadImage(img, cat, name);
  //       // await FirebaseFirestore.instance.collection('category').doc(doc.docs.first['id']).collection('subCategory').doc(element['id']).update({
  //       //   'img': url
  //       // });
  //     });
  //   // (SubCategories[cat] as Map)[''].values.forEach((element) async {
  //   //
  //   // });
  //
  // });

  // Categories.forEach((element) async {
  //   var uuid = Uuid().v4();
  //   await FirebaseFirestore.instance.collection('category').doc(uuid).set({
  //     'categoryName': element,
  //     'id': uuid,
  //     'createdAt': DateTime.now()
  //   });
  // });
}

// Future<File> getImageFileFromAssets(String path) async {
//   final byteData = await rootBundle.load('assets/$path');
//
//   final file = File('${(await getTemporaryDirectory()).path}/$path');
//   await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//
//   return file;
// }
//
// Future<String> uploadImage(File file, String cat, String subCat) async {
//   var uuid = Uuid().v4();
//   var fileExtension = path.extension(file.path);
//   final firebaseStorageRef =
//   FirebaseStorage.instance.ref().child('interest/$cat/$subCat/$uuid$fileExtension');
//   await firebaseStorageRef.putFile(file).catchError((onError) {
//     print(onError);
//     return null;
//   });
//   String url = await firebaseStorageRef.getDownloadURL();
//   return url;
// }

doGoogleLogin(BuildContext context) async {
  AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  String token = await authProvider.signInWithGoogle();
  if (token != null) {
    JumpInUser user = await userServ.getCurrentUser();
    var authUser = await authServ.currentUser();
    if (user != null) {
      userProvider.currentUser = user;
    } else {
      /// user will be able to login - mobile number, if user login with google then directly login and goto interest page not phonenumber
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InterestPage()),
      );
      // if (authUser.phoneNumber != null) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => InterestPage()),
      //   );
      // } else {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
      //   );
      // }
    }
  } else {
    showToast('Error Signing in!');
  }
}

// showModeDialog(BuildContext context,String username) {
//   // set up the buttons
//   Widget cancelButton = FlatButton(
//     child: Text("Company Member"),
//     onPressed:  () async {
//       await userServ.updateMode(AuthService().currentAppUser.uid,1);
//       var userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.currentUser.mode = 1;
//       Provider.of<ModeProvider>(context, listen: false).setCurrentMode(1);
//       Navigator.pop(context);
//       Navigator.pushNamed(context, DashBoardScreen.routeName);
//     },
//   );
//   Widget continueButton = FlatButton(
//     child: Text("General Member"),
//     onPressed:  () async {
//       await userServ.updateMode(AuthService().currentAppUser.uid,0);
//       var userProvider = Provider.of<UserProvider>(context, listen: false);
//       userProvider.currentUser.mode = 0;
//       Provider.of<ModeProvider>(context, listen: false).setCurrentMode(0);
//       Navigator.pop(context);
//       Navigator.pushNamed(context, DashBoardScreen.routeName);
//     },
//   );
//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text("Welcome $username!"),
//     content: Text("Do you want to login as General Member / Company Member?"),
//     actions: [
//       cancelButton,
//       continueButton,
//     ],
//   );
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }

doPhoneNumberLogin(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PhoneNumberScreen(isFromProfile: false)),
  );
}

doAppleLogin(BuildContext context) async {
  AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  try {
    User user = await authProvider
        .signInWithApple(scopes: [Scope.email, Scope.fullName]);
    print('doAppleLogin user displayName ${user.displayName}');
    if (user != null) {
      var authUser = await authServ.currentUser();
      JumpInUser user = await userServ.getCurrentUser();
      if (user != null) {
        userProvider.currentUser = user;
        Navigator.pushNamed(context, DashBoardScreen.routeName);
      } else {
        // print('apple details user ${user.username} ${user.email}');
        /// user will be able to login 3 ways - apple google n mobile number, if user login with apple then directly login and goto interest page not phonenumber
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InterestPage()),
        );
        // if (authUser.phoneNumber != null) {
        //
        // } else {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
        //   );
        // }
      }
    } else {
      showToast('Error Signing in!');
    }
  } catch (e) {
    showToast('Something went wrong!');
    print(e.toString());
  }
}

setUser(BuildContext context, File imgFile, JumpInUser currentUser) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  String id = await locator
      .get<UserService>()
      .uploadUser(img: imgFile, user: currentUser);
  print("user id is $id");
  if (id != null) userProvider.currentUser = await userServ.getCurrentUser();
  if (userProvider.currentUser != null) {
    // Navigator.of(context).push(
    //     PageTransition(child: OnBoardPage(), type: PageTransitionType.fade));
    Navigator.of(context).push(
        PageTransition(child: VideoPlayerScreen(), type: PageTransitionType.fade));
  }
}

// navigateToRoute
navigateToRoute(BuildContext context) async
{
  var userProvider = Provider.of<UserProvider>(context, listen: false);
  JumpInUser user = await userServ.getCurrentUser();
  if (user != null)
  {
    print(' user.id ${user.id}');
     await userServ.updateDeactive(user.id, 1);
     if((user.deactivate != null) && (user.deactivate == 1))
      {
        // showToast('User is deleted.Please create a new account!');
        Timer(Duration(seconds: 6), ()
        {
          Navigator.pushNamed(context, GoogleSignInScreen.routeName);
        });
      }
    else
      {
        userProvider.currentUser = user;
        print("user id is ${user.id}");
        Timer(Duration(seconds: 6), ()
        {
          Navigator.of(context).push(PageTransition(child: DashBoardScreen(),
              type: PageTransitionType.fade));
        });
      }
  }
  else
  {
    Timer(Duration(seconds: 6), ()
    {
      Navigator.pushNamed(context, GoogleSignInScreen.routeName);
    });
  }
}

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await TheAppleSignIn.isAvailable());
  }
}
