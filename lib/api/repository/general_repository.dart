
import 'dart:developer';

import 'package:eagle_eye_admin/api/api_endpoint.dart';

import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/utils/app_constants.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:flutter/material.dart';

import 'package:logic_go_network/network/api_type.dart';
import 'package:logic_go_network/utils/failure.dart';

class GeneralPostRepository {

  static Future<ResponseModel> createGeneralPost({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async
  {
    try {
      log('Data :- $data');
      dynamic response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.createGeneralPost}",
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



  static Future<ResponseModel> updateGeneralPost({
    required BuildContext context,
    required Map<String, dynamic> data,
  })
  async {
    try {
      log('Data :- $data');
      dynamic response = await restClient.putFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.updateGeneralPost}",
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

  static Future<ResponseModel> createGeneralDraft({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async
  {
    try {
      log('Data :- $data');
      dynamic response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.createGeneralDraft}",
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
