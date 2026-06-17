

import 'package:eagle_eye_admin/api/api_endpoint.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/utils/app_constants.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:logic_go_network/network/api_type.dart';
import 'package:logic_go_network/utils/failure.dart';

class RescueRepository {
  static Future<ResponseModel> getAllRescueUpdatesList({
    required String status,
    required String id,

    required BuildContext context,
  }) async
  {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.getRescueUpdates(status,id)}",
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


  static Future<ResponseModel> updateRescueUpdateStatus({
    required String rescueUpdateId,
    required String eventPostId,
    required String status,
    required BuildContext context,

  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.updateRescueUpdateStatus}';

      dynamic response = await restClient.put(
          APIType.protected,
          {
            "eventPostId": eventPostId,
            "rescueUpdateId": rescueUpdateId,
            'rescueUpdateStatus': status
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


  static Future<ResponseModel> updateRescueUpdatePost({
    required Map<String,dynamic> postData,
    required BuildContext context,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.updateRescueUpdatePost}';

      dynamic response = await restClient.postFormData(
          APIType.protected,
          postData,
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

  static Future<ResponseModel> getAllPendingRescueUpdateCount(
      {

       required BuildContext context,
      }) async
  {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.pendingRescueCount}",
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
