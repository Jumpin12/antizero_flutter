import 'package:antizero_jumpin/utils/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering
}

class AuthProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;

  Status get status => _status;

  AuthProvider() {
    authServ.auth.authStateChanges().listen(onAuthStateChanged);
  }

  //detect live auth changes
  Future<void> onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      authServ.userFromFirebase(firebaseUser);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  // login with google
  Future<String> signInWithGoogle() async {
    _status = Status.Authenticating;
    notifyListeners();
    String idString = await authServ.signInGoogle();
    if (idString == null) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    } else {
      return idString;
    }
  }

  // login with apple
  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    _status = Status.Authenticating;
    notifyListeners();
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    User user = await authServ.signInApple(result, scopes);
    if (user == null) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    } else {
      return user;
    }
  }

  //signing out
  Future signOut() async {
    authServ.auth.signOut();
    await GoogleSignIn().signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration(seconds: 0));
  }
}
