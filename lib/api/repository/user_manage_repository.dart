
import 'package:eagle_eye_admin/api/api_endpoint.dart';

import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/utils/app_constants.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:flutter/material.dart';

import 'package:logic_go_network/network/api_type.dart';
import 'package:logic_go_network/utils/failure.dart';

class UserManageRepository {

  static Future<ResponseModel> getAllUsers({
   required String type,
   required String page,
   required String search,
    required BuildContext context,
  }) async
  {
    try {
      dynamic response = await restClient.get(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.getAllUser(type,page,search)}",
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
