import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logic_go_network/network/api_type.dart';

class ApiEndpoint {
  // Auth Module
  static const String loginWithMail = 'auth/login/email';

  // static const String loginWithMail = 'Auth/login/email';
  static const String registerWithMail = 'auth/register/email';

  // static const String registerWithMail = 'Auth/register/email';
  static const String forgotPassword = 'auth/forgot-password/email';
  static const String verifyOtp = 'auth/verify/email/otp';
  static const String resendOtp = 'auth/resend/otp/email';
  static const String verifyToken = 'auth/verify/token';
  static const String changePassword = 'auth/change-password';
  static const String resetPassword = 'auth/reset-password';
  static const String deleteUserAccount = 'auth/delete-account';
  static const String googleSigninRegister = 'auth/login-and-register/google';

  // Event Module
  static const String createEvent = 'event-post/add';
  static const String updateEvent = 'event-post/update';
  static const String updateEventStatus = 'event-post/update-event-post-status';
  static const String filterEvent = 'event-post/filter/';
  static const String singleEvent = 'event-post/';
  static const String updateStatus = 'event-post/update-user-post-status';
  static const String uploadFiles = 'event-post/upload-file';
  static const String addTimeLine = 'event-post/timeline';
  static const String attachPostEvent = 'event-post/file-and-timeline';
  static const String deleteEvent = 'event-post';
  static const String getAttachedVideo = 'event-post';
  static const String updateTimelineFile = 'event-post/update-timeline-file';
  static const String createEventDraft = 'event-post-draft/add';
  static String getEventDrafts(String postType) =>
      'event-post-draft/admin-drafts?postType=$postType';
  static String deleteEventDraft(String draftId) =>
      'event-post-draft/delete/$draftId';

  static String deleteSinglePost(String eventId, String postId) =>
      "event-post/$eventId/timeline-or-attachment/$postId";

  // rescue

  static String getRescueUpdates(String status, String rescueId) =>
      "event-post/rescue-update/$status/$rescueId";
  static const String updateRescueUpdateStatus =
      'event-post/update-rescue-update-status';
  static const String updateRescueUpdatePost = 'event-post/file-and-timeline';
  static const String pendingRescueCount =
      'event-post/pending-rescue-update-count';

// general post
  static const String createGeneralPost = 'general-post/add';
  static const String updateGeneralPost = 'general-post/update';
  static const String createGeneralDraft = 'general-post-draft/add';

  // Reactions & Category
  static const String getReactions = 'event-reaction/list';
  // static  String getCategories(bool isGeneral) => 'event-category/list?isGeneral=$isGeneral';
  static String getCategories(String postType) =>
      'event-category/list?postType=$postType';
  static const String createCategory = 'event-category/add';
  static String createSubCategory(String categoryId) =>
      'event-category/add/$categoryId/sub-category';

  // User Module
  static const String userProfile = 'user/user-profile';
  static const String adminProfile = 'user/profile';

  //Super Admin Module
  static String adminList(String type, String page) =>
      'user/all-admin-users?page=$page&filterType=$type';
  static const String updateAdminStatus =
      'user/update-status-approved-or-rejected';

  //Report Module
  static const String allReportedPost = 'report/post-list';
  static const String allReportedComment = 'report/comment-list';
  static const String allReportedUsers = 'report/user-list';

  static String blockUnblockUser(String userId) =>
      "user/block-app-user/$userId";

  static const String deleteComment = 'report/delete-comment';

  // User Manage Module
  static String getAllUser(String type, String page, String search) =>
      "user/app-users/$type?page=$page&limit=16&search=$search";

  // Update token

  static const String updateToken = 'user/update-fcm-token';
  static const String updateRadius = 'user/update-radius';
  static const String adminProfileGet = 'user/profile';


  /// notify user

  static const String notifyUser = 'notification/send-event-geo-notification';

}

Map<String, String> requestHeader(APIType apiType, {bool? passRefreshToken}) {
  debugPrint('bearer token == ${StorageService.getToken()}');
  return {
    if (apiType == APIType.protected)
      RequestHeaderKey.authorization: "Bearer ${StorageService.getToken()}",
    // RequestHeaderKey.authorization: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2Nzk3NTBkOWY1NzhjZTFlNThlN2YzNWYiLCJpYXQiOjE3NDA2Mjk3NzIsImV4cCI6MTc0MTIzNDU3Mn0.m0fGJm1BIfoXJaS5ray5cRiejSh4BQaDQWjUEd3u6Gc",
  };
}

class RequestHeaderKey {
  static const contentType = "Content-Type";
  static const userAgent = "User-Agent";
  static const authToken = "Auth-Token";
  static const authorization = "Authorization";
}
