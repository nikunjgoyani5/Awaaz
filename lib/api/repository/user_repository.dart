import 'package:eagle_eye_admin/api/api_endpoint.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/utils/app_constants.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:logic_go_network/network.dart';
import 'package:logic_go_network/network/api_type.dart';

class UserRepository {


  static Future<ResponseModel> getAdminProfile({required String userId,
    required BuildContext context,
  }) async
  {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.adminProfileGet}",
          headers: requestHeader(APIType.protected));

      ResponseModel result = ResponseModel.fromJson((response.data));
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } on Failure catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> getUserProfile({required String userId,
  required BuildContext context,
  }) async
  {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.userProfile}/$userId",
          headers: requestHeader(APIType.protected));

      ResponseModel result = ResponseModel.fromJson((response.data));
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } on Failure catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> updateUserToken({required String token,
  required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> data = {'fcmToken': token};
      dynamic response = await restClient.put(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.updateToken}",
          headers: requestHeader(APIType.protected));

      ResponseModel result = ResponseModel.fromJson((response.data));
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } on Failure catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> updateRadius({required double radius,  required BuildContext context,


}) async {
    try {
      Map<String, dynamic> data = {'radius': radius};
      dynamic response = await restClient.put(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.updateRadius}",
          headers: requestHeader(APIType.protected));

      ResponseModel result = ResponseModel.fromJson((response.data));
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } on Failure catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> updateAdminProfile({required Map<String,dynamic> data,
    required BuildContext context,
  }) async {
    try {

      dynamic response = await restClient.putFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.adminProfile}",
          headers: requestHeader(APIType.protected));

      ResponseModel result = ResponseModel.fromJson((response.data));
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } on Failure catch (e) {
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }


}
