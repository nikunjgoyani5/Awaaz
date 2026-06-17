
import 'package:eagle_eye_admin/api/api_endpoint.dart';

import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/utils/app_constants.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:flutter/material.dart';

import 'package:logic_go_network/network/api_type.dart';
import 'package:logic_go_network/utils/failure.dart';

class ReportRepository {

  static Future<ResponseModel> getAllReportedPost({    required BuildContext context,}) async
  {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.allReportedPost}",
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



  static Future<ResponseModel> getAllReportedUser({    required BuildContext context,}) async
  {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.allReportedUsers}",
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
  static Future<ResponseModel> getAllReportedComments({    required BuildContext context,}) async
  {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.allReportedComment}",
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


  static Future<ResponseModel> userBlockUnblock({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.blockUnblockUser(userId)}';

      dynamic response = await restClient.put(
          APIType.protected,
          {

          },
          path: url,
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

  static Future<ResponseModel> deleteCommentAPI({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.deleteComment}';

      dynamic response = await restClient.delete(
          APIType.protected,


          path: url,
          data: data,
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
      String finalError = splitError[0];   if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }

      return ResponseModel(message: finalError, body: null, status: false);
    }
  }
}
