import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static late SharedPreferences _pref;

  static init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static const String email = "email";
  static const String emailLogin = "emailLogin";
  static const String deviceLogin = "deviceLogin";
  static const String googleLogin = "googleLogin";
  static const String appleLogin = "appleLogin";
  static const String password = "password";
  static const String remember = "remember";
  static const String mobileNumber = "mobileNumber";
  static const String userId = "userId";
  static const String name = "name";
  static const String userName = "userName";
  static const String oneSignalId = "oneSignalId";
  static const String oneSignalSubscriptionId = "oneSignalSubscriptionId";
  static const String userRadius = "userRadius";
  static const String profileUrl = "profileUrl";
  static const String dateOfBirth = "dateOfBirth";
  static const String isLogin = "isLogin";
  static const accessToken = "Access-Token";
  static const refreshToken = "Refresh-Token";
  static const String countryCode = "CountryCode";
  static const String currentAddress = "currentAddress";
  static const String currentCity = "currentCity";
  static const String languageKey = "LanguageKey";
  static const String languageValue = "LanguageValue";
  static const String selectLanguageIcon = "SelectIcon";
  static const String eventDetailsId = "eventDetailsId";
  static const String videoQualityIndex = 'videoQuality';
  static const String addressStampIndex = 'addressStamp';
  static const String goLiveTutorial = 'goLiveTutorial';
  static const String isAppOpenNotification = 'isAppOpenNotification';
  static const String startLiveTutorial = 'startLiveTutorial';
  static const String isRate = 'isRate';

  static setValue(String key, value) async {
    if (value is String) {
      await _pref.setString(key, value);
    } else if (value is int) {
      await _pref.setInt(key, value);
    } else if (value is double) {
      await _pref.setDouble(key, value);
    } else if (value is bool) {
      await _pref.setBool(key, value);
    } else if (value is List<String>) {
      await _pref.setStringList(key, value);
    }
  }

  static String getString(String key) {
    return _pref.getString(key) ?? '';
  }

  static int getInt(String key) {
    return _pref.getInt(key) ?? 0;
  }

  static double getDouble(String key) {
    return _pref.getDouble(key) ?? 0.0;
  }

  static bool getBool(String key) {
    return _pref.getBool(key) ?? false;
  }

  static List<String> getStringList(String key) {
    return _pref.getStringList(key) ?? [];
  }

  static clear() async {
    await _pref.clear();
  }

  static singleclear(String key) async {
    await _pref.remove(key);
  }
}
