import 'package:logic_go_network/network/api_type.dart';
import 'package:logic_go_network/utils/failure.dart';
import 'package:eagle_eye/data/api_end_points.dart';
import 'package:flutter/material.dart';

import '../../core/constant/app_constant.dart';
import '../models/response_model.dart';

class AuthRepository {
  static Future<ResponseModel> loginWithEmail(
      {required Map<String, dynamic> data}) async {
    try {
      dynamic response = await restClient.post(APIType.public, data,
          path: "$baseUrl/${ApiEndPoint.loginWithMail}",
          headers: requestHeader(APIType.public));

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
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> loginWithPhone(
      {required Map<String, dynamic> data}) async {
    try {
      dynamic response = await restClient.post(APIType.public, data,
          path: "$baseUrl/${ApiEndPoint.loginWithMobile}",
          headers: requestHeader(APIType.public));

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
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> registerWithEmail(
      {required Map<String, dynamic> data}) async {
    final response = await restClient.post(APIType.public, data,
        path: "$baseUrl/${ApiEndPoint.registerWithMail}",
        headers: requestHeader(APIType.public));
    ResponseModel result = ResponseModel.fromJson(response.data);

    try {
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
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> forgotPassword(
      {required Map<String, dynamic> data}) async {
    final response = await restClient.post(APIType.public, data,
        path: "$baseUrl/${ApiEndPoint.forgotPassword}",
        headers: requestHeader(APIType.public));
    ResponseModel result = ResponseModel.fromJson(response.data);

    try {
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
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> verifyEmailOtp(
      {required Map<String, dynamic> data}) async {
    final response = await restClient.post(APIType.public, data,
        path: "$baseUrl/${ApiEndPoint.verifyMainOtp}",
        headers: requestHeader(APIType.public));
    ResponseModel result = ResponseModel.fromJson(response.data);

    try {
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      debugPrint('Error ${e.toString()}');
      return ResponseModel(
          message: result.message, body: result.body, status: result.status);
    }
  }

  static Future<ResponseModel> verifyPhoneOtp(
      {required Map<String, dynamic> data}) async {
    final response = await restClient.post(APIType.public, data,
        path: "$baseUrl/${ApiEndPoint.verifyPhoneOtp}",
        headers: requestHeader(APIType.public));
    ResponseModel result = ResponseModel.fromJson(response.data);

    try {
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      debugPrint('Error ${e.toString()}');
      return ResponseModel(
          message: result.message, body: result.body, status: result.status);
    }
  }

  static Future<ResponseModel> resendOTPMail({required String email}) async {
    final response = await restClient.post(APIType.public, {'email': email},
        path: "$baseUrl/${ApiEndPoint.resendOtp}",
        headers: requestHeader(APIType.public));
    ResponseModel result = ResponseModel.fromJson(response.data);

    try {
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      debugPrint('Error ${e.toString()}');
      return ResponseModel(
          message: result.message, body: result.body, status: result.status);
    }
  }

  static Future<ResponseModel> resetPassword(
      {required String password, required String email}) async {
    final response = await restClient.post(APIType.public,
        {'password': password, 'confirmPassword': password, 'email': email},
        path: "$baseUrl/${ApiEndPoint.resetPassword}",
        headers: requestHeader(APIType.public));

    ResponseModel result = ResponseModel.fromJson(response.data);

    try {
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      debugPrint('Error ${e.toString()}');
      return ResponseModel(
          message: result.message, body: result.body, status: result.status);
    }
  }

  static Future<ResponseModel> changePassword(
      {required String oldPassword, required String newPassword}) async {
    final response = await restClient.post(
        APIType.public,
        {
          "oldPassword": oldPassword,
          "newPassword": newPassword,
          "confirmNewPassword": newPassword
        },
        path: "$baseUrl/${ApiEndPoint.changePassword}",
        headers: requestHeader(APIType.protected));
    ResponseModel result = ResponseModel.fromJson(response.data);

    try {
      if (result.status == true) {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      } else {
        return ResponseModel(
            message: result.message, body: result.body, status: result.status);
      }
    } catch (e) {
      debugPrint('Error ${e.toString()}');
      return ResponseModel(
          message: result.message, body: result.body, status: result.status);
    }
  }

  static Future<ResponseModel> googleSinIn(
      {required Map<String, dynamic> data}) async {
    try {
      dynamic response = await restClient.post(APIType.public, data,
          path: "$baseUrl/${ApiEndPoint.googleSignIn}",
          headers: requestHeader(APIType.public));

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
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  static Future<ResponseModel> appleSinIn(
      {required Map<String, dynamic> data}) async {
    try {
      dynamic response = await restClient.post(APIType.public, data,
          path: "$baseUrl/${ApiEndPoint.appleSignIn}",
          headers: requestHeader(APIType.public));

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
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }
}
