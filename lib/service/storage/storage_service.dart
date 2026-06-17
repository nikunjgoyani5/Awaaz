import 'dart:developer';

import 'package:get_storage/get_storage.dart';

import 'storage_key.dart';

class StorageService {
  static final storage = GetStorage();

  static void storeToken(String? token) {
    if (token == null) {
      storage.remove(StorageKeys.token);
      return;
    }
    storage.write(StorageKeys.token, token);
  }

  static String? getToken() {
    return storage.read(StorageKeys.token);
  }

  // Method for get Email
  static String? getEmail() {
    return storage.read(StorageKeys.email);
  }

  static void saveEmail(String email) {
    storage.write(StorageKeys.email, email);
  }

  // Method for remove token
  static void removeToken() {
    storage.remove(StorageKeys.token);
  }

  static double? getLatitude() {
    return storage.read(StorageKeys.latitude);
  }

  static void saveLatitude(double lat) {
    storage.write(StorageKeys.latitude, lat);
  }

  static double? getLongitude() {
    return storage.read(StorageKeys.longitude);
  }

  static void saveLongitude(double long) {
    storage.write(StorageKeys.longitude, long);
  }

  static double? getCurrentLatitude() {
    return storage.read(StorageKeys.currentLatitude);
  }

  static void saveCurrentLatitude(double lat) {
    storage.write(StorageKeys.currentLatitude, lat);
  }

  static double? getCurrentLongitude() {
    return storage.read(StorageKeys.currentLongitude);
  }

  static void saveCurrentLongitude(double long) {
    storage.write(StorageKeys.currentLongitude, long);
  }

  static String? getName() {
    return storage.read(StorageKeys.name);
  }
  static String? getProfilePic() {
    return storage.read(StorageKeys.profilePic);
  }
  static void saveName(String name) {
    storage.write(StorageKeys.name, name);
  }static void saveProfilePic(String profilePic) {
    storage.write(StorageKeys.profilePic, profilePic);
  }

  static String? getPass() {
    return storage.read(StorageKeys.password);
  }

  static void savePass(String pass) {
    storage.write(StorageKeys.password, pass);
  }

  static bool? getIsSuperAdmin() {
    return storage.read(StorageKeys.isSuperAdmin);
  }

  static void saveIsSuperAdmin(bool isSuperAdmin) {
    storage.write(StorageKeys.isSuperAdmin, isSuperAdmin);
  }

  static bool? getIsSaveCredentials() {
    return storage.read(StorageKeys.isSaveCredentials);
  }

  static void saveCredentials(bool isSaveCredentials) {
    storage.write(StorageKeys.isSaveCredentials, isSaveCredentials);
  }

  static void removeSuperAdmin() {
    storage.remove(StorageKeys.isSuperAdmin);
  }

  static String? getEventId() {
    return storage.read(StorageKeys.eventId);
  }

  static void saveEventId(String id) {
    storage.write(StorageKeys.eventId, id);
  }

  static String? getUserPost() {
    return storage.read(StorageKeys.userPost);
  }

  static void saveUserPOst(String userPost) {
    storage.write(StorageKeys.userPost, userPost);
  }

  static int getSelectedTab() {
    return storage.read(StorageKeys.selectedTab) ?? 0;
  }

  static void saveSelectedTab(int selectedTab) {
    storage.write(StorageKeys.selectedTab, selectedTab);
  }

  static double getSubSelectedTab() {
    return storage.read(StorageKeys.selectedSubTab);
  }

  static void saveSelectedSubTab(double selectedSubTab) {
    storage.write(StorageKeys.selectedSubTab, selectedSubTab);
  }


  static String? getAddress() {
    return storage.read(StorageKeys.address);
  }

  static void saveAddress(String address) {
    storage.write(StorageKeys.address, address);
  }

  static String? getCurrentAddress() {
    return storage.read(StorageKeys.currentAddress);
  }

  static void saveCurrentAddress(String currentAddress) {
    storage.write(StorageKeys.currentAddress, currentAddress);
  }



  static void clearStorage() {
    storage.erase();
    removeToken();
    removeSuperAdmin();
    log("All keys removed from GetStorage!");
  }



}
