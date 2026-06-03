import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseEvents {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static setFirebaseEvent(String screenName, Map<String, String> parameters) {
    FirebaseAnalytics.instance.logEvent(
      name: screenName,
      parameters: parameters,
    );
  }
}
