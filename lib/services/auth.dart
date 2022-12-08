import 'dart:async';

import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User currentAppUser = FirebaseAuth.instance.currentUser;

  // current firebase user
  Future<User> currentUser() async {
    User firebaseUser = auth.currentUser;
    if (firebaseUser != null) {
      return firebaseUser;
    } else {
      return null;
    }
  }

  // get user
  Future<JumpInUser> getUser() async {
    User user = await currentUser();
    if (user == null)
    {
      return null;
    }
    return userServ.getCurrentUser();
  }

  //Create user object based on the given FirebaseUser
  Future<JumpInUser> userFromFirebase(User firebaseUser) async {
    if (firebaseUser == null) {
      return null;
    }
    return userServ.getCurrentUser();
  }

  // sign in google
  Future<String> signInGoogle() async {
    try {
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication googleAuth = await account.authentication;
        try {
          await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
          return googleAuth.idToken;
        } catch (e) {
          debugPrint(e.toString());
          print('\n \n error in signing in with google!! ${e.toString()}');
          // showToast(e.toString());
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('\n \n error in signing in with google!! ${e.toString()}');
      // showToast(e.toString());
      return null;
    }
  }

  // login with apple
  Future<User> signInApple(
      AuthorizationResult result, List<Scope> scopes) async {
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final userCredential = await auth.signInWithCredential(credential);
        final firebaseUser = userCredential.user;
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
             print('displayName ${displayName}');
          }
        }
        if (scopes.contains(Scope.email)) {
          final email = appleIdCredential.email;
          if (email != null &&
              email.length>0)
          {
            await firebaseUser.updateEmail(email);
             print('email ${email}');
          }
        }

        return firebaseUser;
      case AuthorizationStatus.error:
        return null;

      case AuthorizationStatus.cancelled:
        return null;
      default:
        return null;
    }
  }
}
