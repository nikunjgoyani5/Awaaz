import 'package:eagle_eye_admin/api/api_endpoint.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/utils/app_constants.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:logic_go_network/network.dart';
import 'package:logic_go_network/network/api_type.dart';

class AuthRepository {
  static Future<ResponseModel> loginWithEmail({
    required Map<String, dynamic> data,
    required BuildContext context,
  }) async {
    try {
      dynamic response = await restClient.post(APIType.public, data,
          path: "$baseUrl/${ApiEndpoint.loginWithMail}",
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
      if (error[2].split(',').first == '401') {
        // AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  // Register with email and password

  static Future<ResponseModel> registerWithEmail(
      {required String email,
      required String password,
      required BuildContext context,
      required String name}) async {
    try {
      dynamic response = await restClient.post(
          APIType.public, {'email': email, 'password': password, 'name': name},
          path: "$baseUrl/${ApiEndpoint.registerWithMail}",
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
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  // verify email otp

  static Future<ResponseModel> verifyEmailOtp(
      {required String otp,
      required String email,
      required BuildContext context}) async {
    try {
      dynamic response = await restClient.post(
          APIType.public,
          {
            'otp': num.parse(otp),
            'email': email,
          },
          path: "$baseUrl/${ApiEndpoint.verifyOtp}",
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
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  // Forgot password with mail address

  static Future<ResponseModel> forgotPasswordWithEmail(
      {required String email, required BuildContext context}) async {
    try {
      dynamic response = await restClient.post(APIType.public, {'email': email},
          path: "$baseUrl/${ApiEndpoint.forgotPassword}",
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
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  // Reset password with token

  static Future<ResponseModel> resetPassword(
      {required String password,
      required String email,
      required BuildContext context}) async {
    try {
      dynamic response = await restClient.post(APIType.public,
          {'password': password, 'confirmPassword': password, 'email': email},
          path: "$baseUrl/${ApiEndpoint.resetPassword}",
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
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }

      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  // resend otp on mail address

  static Future<ResponseModel> resendOTPEmail(
      {required String email, required BuildContext context}) async {
    try {
      dynamic response = await restClient.post(APIType.public, {'email': email},
          path: "$baseUrl/${ApiEndpoint.resendOtp}",
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
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  // Change password with token
/*  static Future<Response?> changePassword(
      {required BuildContext context,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    try {
      return await ApiController.patch(
        ApiEndpoint.changePassword,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmNewPassword': confirmPassword,
        },
        context: context,
      );
    } catch (e) {
      return null;
    }
  }*/

  static Future<ResponseModel> changePassword(
      {required String oldPassword,
      required String newPassword,
      required BuildContext context,
      required String confirmPassword}) async {
    try {
      dynamic response = await restClient.patch(
          APIType.public,
          {
            'oldPassword': oldPassword,
            'newPassword': newPassword,
            'confirmNewPassword': confirmPassword,
          },
          path: "$baseUrl/${ApiEndpoint.changePassword}",
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
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }

  // Google login and register

  static Future<ResponseModel> loginWithGoogle(
      {required String email, required BuildContext context}) async {
    try {
      dynamic response = await restClient.post(APIType.public, {'email': email},
          path: "$baseUrl/${ApiEndpoint.googleSigninRegister}",
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
      if (error[2].split(',').first == '401') {
        AppFunctions.onTokenExpire(context);
      }
      return ResponseModel(message: finalError, body: null, status: false);
    }
  }
}
