
import 'package:eagle_eye_admin/api/api_endpoint.dart';

import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/utils/app_constants.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:flutter/material.dart';

import 'package:logic_go_network/network/api_type.dart';
import 'package:logic_go_network/utils/failure.dart';

class SuperAdminRepository {

  static Future<ResponseModel> getAllAdmins(
  {required String status,
    required String page,
    required BuildContext context,

  }

      ) async
  {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.adminList( status, page)}",
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




  static Future<ResponseModel> adminStatusChange({
    required BuildContext context,
    required String status,
    required String registerAdminId,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.updateAdminStatus}';

      dynamic response = await restClient.patch(
          APIType.protected,
          {
            "status": status,
            "registerAdminId": registerAdminId,

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






}
