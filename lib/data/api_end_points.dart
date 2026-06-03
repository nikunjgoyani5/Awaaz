import 'dart:developer';

import 'package:logic_go_network/network/api_type.dart';

import '../core/utils/app_prefrence.dart';

class ApiEndPoint {
  // authentication
  static const String loginWithMail = 'api/v1/auth/login/email';
  static const String loginWithDeviceId = 'api/v1/auth/guest-login';
  static const String loginWithMobile = 'api/v1/auth/login-or-register/mobile';
  static const String loginWithGoogle = 'api/v1/auth/login/google';
  static const String registerWithMail = 'api/v1/auth/register/email';
  static const String forgotPassword = 'api/v1/auth/forgot-password/email';
  static const String verifyMainOtp = 'api/v1/auth/verify/email/otp';
  static const String verifyPhoneOtp = 'api/v1/auth/verify/mobile/otp';
  static const String resendOtp = 'api/v1/auth/resend/otp/email';
  static const String resetPassword = 'api/v1/auth/reset-password';
  static const String changePassword = 'api/v1/auth/change-password';
  static const String googleSignIn = 'api/v1/auth/login/google';
  static const String appleSignIn = 'api/v1/auth/login/apple';

  // main
  static const String user = 'api/v1/user/profile';
  static const String report = 'api/v1/report/create';
  static const String blockUnBlockUser = 'api/v1/user/block-unblock-user';
  static const String blockUserList = 'api/v1/user/block-users';
  static const String savePost = 'api/v1/event-post/save-post';
  static const String selectedAreaPostEvents = 'api/v1/event-post/map/in-this-area-events';
  static const String searchEventPostWithHashtag = 'api/v1/event-post/search';
  static const String updateUserCurrentLocation = 'api/v1/user/update/location';
  static const String updatePushToken = 'api/v1/user/update-push-token';

  static String getSupportList(String status) => "api/v1/support/support-request/list?status=$status";
  static const String addSupport = 'api/v1/support/support-request/add';
  static const String addViewCount = 'api/v1/event-post/add-view';
  static const String addReactionPost = 'api/v1/event-post/add-reaction';
  static const String updateUserRadius = 'api/v1/user/update-radius';
  static const String postEvent = 'api/v1/event-post/add';
  static const String postDraftEvent = 'api/v1/event-post-draft/add';
  static const String getDraftEvent = 'api/v1/event-post-draft/user-drafts';
  static const String updateRescue = 'api/v1/event-post/rescue-update';
  static const String checkUserName = 'api/v1/user/check/username';
  static const String generalAddPost = 'api/v1/general-post/add';
  static const String generalPostDraft = 'api/v1/general-post-draft/add';

  static String searchUserByUsername(String searchValue) {
    return 'api/v1/user/search-by-users-username?search=$searchValue';
  }

  static String eventNewsList(String type, int page, int limit, {String? postType}) {
    String url = 'api/v1/event-post/event-post-news?filterType=$type&page=$page&limit=$limit';
    if (postType != null) {
      url += '&postType=$postType';
    }
    return url;
  }

  static const String deleteUserAccount = 'api/v1/user/delete-account';

  static String getNotificationAlertList(int page, int limit) =>
      'api/v1/notification/get-user-notifications?page=$page&limit=$limit';

  static String getInThisAreaPostList(String postId) => "api/v1/event-post/in-this-area-events/$postId";

  static String getEventNewsDetailData(String postId) => "api/v1/event-post/$postId";

  static String getEventReactionList(String value) => "api/v1/event-post/event-category-list?$value";

  static String getOtherUserProfile(String userId) => "api/v1/user/user-profile/$userId";

  static String eventPostCommentList(String postId) => "api/v1/event-post/$postId/comments";
  static String notificationOnOff = "api/v1/event-post/on-off-notication";
  static String getUsers = 'api/v1/user/count-users-in-radius';
  static String addViewAttachment = 'api/v1/event-post/add-view-attachment';

  /////

  static String getGeneralEventCategoryList = "api/v1/event-post/event-category-list?postType=general_category";
}

Map<String, String> requestHeader(APIType apiType, {bool? passRefreshToken}) {
  log('bearer token == ${PrefService.getString(PrefService.accessToken)}');
  return {
    // RequestHeaderKey.contentType: "application/json",
    if (apiType == APIType.protected)
      RequestHeaderKey.authorization: "Bearer ${PrefService.getString(PrefService.accessToken)}",
    // "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2Njk3NDhjYzhkOWY3NTY5Njg0NGY1MWUiLCJpYXQiOjE3MjExOTA2NTAsImV4cCI6MTcyMTc5NTQ1MH0.NVfXKD7ABmtxE6S3avC1Kgum7ame_xj88acBpbH2FNE",
  };
}

class RequestHeaderKey {
  static const contentType = "Content-Type";
  static const userAgent = "User-Agent";
  static const authToken = "Auth-Token";
  static const authorization = "Authorization";
}
