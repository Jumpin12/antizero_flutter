import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class Analytics {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> logCustomEvent(
      {String eventName, Map<String, dynamic> params}) async {
    await analytics.logEvent(
      name: eventName,
      parameters: params,
    );
    debugPrint('$eventName logged');
  }
}
