import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/screens/authentication/interest.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status { Uninitialized, AutoVerified, OtpSend, Failed, TimeOut }

class PhoneAuth extends ChangeNotifier {
  Status _status = Status.Uninitialized;
  String verificationID;

  Status get status => _status;

  // phone auth
  Future<void> verifyPhoneNumber(BuildContext context, String number) async {
    PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      try {
        UserCredential userCred = await authServ.auth.currentUser
            .linkWithCredential(phoneAuthCredential);
        _status = Status.AutoVerified;
        notifyListeners();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                      "User Verified by reading the otp from SMS on device"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InterestPage()),
                        );
                      },
                      child: const Text('Alright'),
                    )
                  ],
                ));
      } on FirebaseAuthException catch (error) {
        print(error.code);
        showToast('${error.message}');
        _status = Status.Uninitialized;
        notifyListeners();
        Navigator.pop(context);
      }
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showToast(authException.toString());
      _status = Status.Failed;
      notifyListeners();
      Navigator.pop(context);
    };

    PhoneCodeSent codeSent = (String verId, [int forceResendingToken]) async {
      this.verificationID = verId;
      _status = Status.OtpSend;
      notifyListeners();
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationID = verificationId;
      if (_status != null && _status != Status.AutoVerified) {
        _status = Status.TimeOut;
        notifyListeners();
        showToast('Timeout, Please retry');
        Navigator.of(context, rootNavigator: true).pop();
      }
    };

    try {
      await authServ.auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      print('Error in signing : ${e.toString()}');
    }
  }

  // login with otp
  Future<bool> verifyOTP(BuildContext context, String otp) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID,
      smsCode: otp,
    );
    try {
      final User user =
          (await  authServ.auth.signInWithCredential(credential)).user;
      print('user ${user.uid}');
      _status = Status.AutoVerified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      showToast('${error.message}');
      _status = Status.Uninitialized;
      notifyListeners();
      return false;
    }
  }
}
