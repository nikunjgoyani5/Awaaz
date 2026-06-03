import 'package:dio/dio.dart';
import 'package:logic_go_network/network/api_type.dart';
import 'package:logic_go_network/utils/failure.dart';

import '../../core/constant/app_constant.dart';
import '../../core/utils/app_functions.dart';
import '../api_end_points.dart';
import '../models/response_model.dart';

class MainRepository {
  static Future<ResponseModel> updateProfile({required Map<String, dynamic> data}) async {
    try {
      dynamic response = await restClient.putFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.user}", headers: requestHeader(APIType.protected));

      ResponseModel result = ResponseModel.fromJson((response.data));
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } on Failure catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> deviceAuth({required Map<String, dynamic> data}) async {
    try {
      dynamic response = await restClient.post(APIType.public, data,
          path: "$baseUrl/${ApiEndPoint.loginWithDeviceId}", headers: requestHeader(APIType.public));

      ResponseModel result = ResponseModel.fromJson((response.data));
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } on Failure catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getMyProfile() async {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.user}", headers: requestHeader(APIType.protected));

      ResponseModel result = ResponseModel.fromJson((response.data));
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } on Failure catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getMyDraftData() async {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.getDraftEvent}", headers: requestHeader(APIType.protected));

      ResponseModel result = ResponseModel.fromJson((response.data));
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } on Failure catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> report({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.report}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> onOrOffEventNotification({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.notificationOnOff}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> blockUser({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.blockUnBlockUser}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> addViewCountPost({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.addViewCount}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> addReactionPost({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.addReactionPost}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> updateUserRadius({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.put(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.updateUserRadius}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> savePost({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.savePost}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> updatePushToken({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.put(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.updatePushToken}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> savedPostList() async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.savePost}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getNotificationAlertList(int page) async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.getNotificationAlertList(page, 10)}",
          headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getOtherUserProfile(String userId) async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.getOtherUserProfile(userId)}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getSupportList(String status) async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.getSupportList(status)}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> addSupport({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.addSupport}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> postEvent({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.postEvent}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> postDraftEvent({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.postDraftEvent}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> updateRescue({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.updateRescue}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getEventNewsDetailData({required String postId}) async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.getEventNewsDetailData(postId)}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getReactionList({required String value}) async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.getEventReactionList(value)}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> inThisAreaPostList({required String postId}) async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.getInThisAreaPostList(postId)}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> blockedUserList() async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.blockUserList}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> eventNewsList(String type, int page, {String? postType}) async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.eventNewsList(type, page, 10, postType: postType)}",
          headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> eventPostCommentList(String postId) async {
    try {
      final response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.eventPostCommentList(postId)}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> selectedAreaPostEvents({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.selectedAreaPostEvents}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> searchEventPostWithHashtag({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.searchEventPostWithHashtag}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> updateUserCurrentLocation({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.updateUserCurrentLocation}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> deleteUserAccount() async {
    try {
      final response = await restClient.delete(APIType.protected,
          path: "$baseUrl/${ApiEndPoint.deleteUserAccount}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getUsersOfMyLocation({
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await restClient.post(
        APIType.protected,
        data,
        path: '$baseUrl/${ApiEndPoint.getUsers}',
        headers: requestHeader(APIType.protected),
      );
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      return ResponseModel(message: 'Something went wrong.', body: null, status: false);
    }
  }

  static Future<ResponseModel> addViewAttachment({
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await restClient.post(
        APIType.protected,
        data,
        path: '$baseUrl/${ApiEndPoint.addViewAttachment}',
        headers: requestHeader(APIType.protected),
      );
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      return ResponseModel(message: 'Something went wrong.', body: null, status: false);
    }
  }

  static Future<ResponseModel> checkUserName({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.checkUserName}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getUsersByUsername({
    required String searchValue,
  }) async {
    try {
      Response response = await restClient.get(
        APIType.protected,
        path: '$baseUrl/${ApiEndPoint.searchUserByUsername(searchValue)}',
        headers: requestHeader(APIType.protected),
      );
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      return ResponseModel(message: 'Something went wrong.', body: null, status: false);
    }
  }

////////////
  static Future<ResponseModel> generalAddPostApi({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.generalAddPost}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> generalPostDraft({required Map<String, dynamic> data}) async {
    try {
      final response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndPoint.generalPostDraft}", headers: requestHeader(APIType.protected));
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];

      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire();
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> generalEventCat() async {
    try {
      Response response = await restClient.get(
        APIType.protected,
        path: '$baseUrl/${ApiEndPoint.getGeneralEventCategoryList}',
        headers: requestHeader(APIType.protected),
      );
      ResponseModel result = ResponseModel.fromJson(response.data);
      if (result.status == true) {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      return ResponseModel(message: 'Something went wrong.', body: null, status: false);
    }
  }
}
