import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:flutter/material.dart';

class JumpInButtonProvider extends ChangeNotifier {
  bool _loading;
  bool _requesting;
  bool _requested;

  JumpInButtonProvider(BuildContext context, String id) {
    this._loading = false;
    this._requesting = false;
    this._requested = false;
    checkConnected(context, id: id);
  }

  bool get loading => _loading;
  bool get requesting => _requesting;
  bool get requested => _requested;

  setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  setRequesting(bool val) {
    _requesting = val;
    notifyListeners();
  }

  setRequested(bool val) {
    _requested = val;
    notifyListeners();
  }

  checkConnected(BuildContext context, {String id}) async {
    setLoading(true);
    FriendRequest friendRequest =
        await checkIfRequestedForConnection(context, id);
    if (friendRequest != null) {
      _requested = true;
    }
    setLoading(false);
  }
}
