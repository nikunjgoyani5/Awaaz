import 'dart:developer';

import 'package:eagle_eye_admin/api/api_endpoint.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/utils/app_constants.dart';
import 'package:eagle_eye_admin/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:logic_go_network/network/api_type.dart';
import 'package:logic_go_network/utils/failure.dart';

class EventRepository {
  static Future<ResponseModel> createEventPost({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async {
    try {
      log('Data :- $data');
      dynamic response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.createEvent}",
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

  static Future<ResponseModel> updateEvent({
    required BuildContext context,
    required Map<String, dynamic> data,
  })
  async {
    try {
      log('Data :- $data');
      dynamic response = await restClient.putFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.updateEvent}",
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

  static Future<ResponseModel> updateEventStatus({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async {
    try {
      log('Data :- $data');
      dynamic response = await restClient.put(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.updateEventStatus}",
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

  static Future<ResponseModel> getFilterEventList({
    required String filterType,
    required String postType,
    required String page,
    required String date,
    required bool isDate,
    required double latitude,
    required double longitude,
    required bool isFilter,
    required String search,
    String? status,
    String? categoryList,
    required double distance,
    required BuildContext context,
  }) async {
    try {
      String url;

      ///old
      // if (isFilter) {
      //   if (isDate) {
      //     url =
      //         '$baseUrl/${ApiEndpoint.filterEvent}$postType/$filterType?page=$page&date=$date&distance=$distance&lat=$latitude&lon=$longitude&search=$search';
      //   } else {
      //     url =
      //         '$baseUrl/${ApiEndpoint.filterEvent}$postType/$filterType?page=$page&distance=$distance&lat=$latitude&lon=$longitude&search=$search';
      //   }
      // } else {
      //   url =
      //       '$baseUrl/${ApiEndpoint.filterEvent}$postType/$filterType?page=$page&search=$search';
      // }
      //
      //
      // if(status ==  'Resolved'){
      //   url =   '$baseUrl/${ApiEndpoint.filterEvent}$postType/Approved?page=$page&search=$search&status=$status';
      // }

      ///NEW

      if (postType == 'general_category') {
        if (isFilter) {
          url =
              "$baseUrl/${ApiEndpoint.filterEvent}$postType/$filterType?page=$page&date=$date&distance=$distance&lat=$latitude&lon=$longitude&search=$search&category=$categoryList";
        } else {
          url =
              '$baseUrl/${ApiEndpoint.filterEvent}$postType/$filterType?page=$page&search=$search&category=$categoryList';
        }
      } else {
        if (isFilter) {
          url =
              '$baseUrl/${ApiEndpoint.filterEvent}$postType/$filterType?page=$page&date=$date&distance=$distance&lat=$latitude&lon=$longitude&search=$search';
          if (status == 'Resolved') {
            url =
                '$baseUrl/${ApiEndpoint.filterEvent}$postType/Approved?page=$page&date=$date&distance=$distance&lat=$latitude&lon=$longitude&search=$search&status=$status';
          }
        } else {
          url =
              '$baseUrl/${ApiEndpoint.filterEvent}$postType/$filterType?page=$page&search=$search';
          if (status == 'Resolved') {
            url = '$baseUrl/${ApiEndpoint.filterEvent}$postType/Approved?page=$page&search=$search&status=$status';
          }
        }



      }

      dynamic response = await restClient.get(APIType.protected,
          path: url, headers: requestHeader(APIType.protected));

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

  static Future<ResponseModel> getSingleEvent({
    required String id,
    required String postType,
    required BuildContext context,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.singleEvent}$postType/$id';

      dynamic response = await restClient.get(APIType.protected,
          path: url, headers: requestHeader(APIType.protected));

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

  static Future<ResponseModel> eventStatusChange({
    required bool isSendNotification,
    required String status,
    required String eventPostId,
    required BuildContext context,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.updateStatus}';

      dynamic response = await restClient.put(
          APIType.protected,
          {
            "status": status,
            "eventPostId": eventPostId,
            "isSendNotification": isSendNotification
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

  static Future<ResponseModel> uploadFilesAPi({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async {
    try {
      log('Data :- $data');
      dynamic response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.uploadFiles}",
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

  static Future<ResponseModel> addTimeLineAPI({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async {
    try {
      log('Data :- $data');
      dynamic response = await restClient.post(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.addTimeLine}",
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

  static Future<ResponseModel> attachPostEvent({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async {
    try {
      log('Data :- $data');
      dynamic response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.attachPostEvent}",
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

  static Future<ResponseModel> deleteEvent(
      {required id, required BuildContext context}) async {
    try {
      dynamic response = await restClient.delete(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.deleteEvent}/$id",
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

  static Future<ResponseModel> getAttachedVideosList({
    required String id,
    required BuildContext context,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.getAttachedVideo}/$id/upload-files';

      dynamic response = await restClient.get(APIType.protected,
          path: url, headers: requestHeader(APIType.protected));

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

  static Future<ResponseModel> updateTimeLineVideo({
    required Map<String, dynamic> data,
    required BuildContext context,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.updateTimelineFile}';

      dynamic response = await restClient.putFormData(APIType.protected, data,
          path: url, headers: requestHeader(APIType.protected));

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

  static Future<ResponseModel> deleteSinglePost({
    required String eventId,
    required String postId,
    required BuildContext context,
  }) async {
    try {
      dynamic response = await restClient.delete(APIType.protected,
          path: "$baseUrl/${ApiEndpoint.deleteSinglePost(eventId, postId)}",
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

  static Future<ResponseModel> createEventDraft({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async
  {
    try {
      log('Data :- $data');
      dynamic response = await restClient.postFormData(APIType.protected, data,
          path: "$baseUrl/${ApiEndpoint.createEventDraft}",
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

  static Future<ResponseModel> getEventDrafts({
    required BuildContext context,
    required String postType,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.getEventDrafts(postType)}';

      dynamic response = await restClient.get(APIType.protected,
          path: url, headers: requestHeader(APIType.protected));

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

  static Future<ResponseModel> deleteEventDraft({
    required String draftId,
    required BuildContext context,
  }) async {
    try {
      String url = '$baseUrl/${ApiEndpoint.deleteEventDraft(draftId)}';

      dynamic response = await restClient.delete(APIType.protected,
          path: url, headers: requestHeader(APIType.protected));

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
  static Future<ResponseModel> notifyUserAPI({required Map<String,dynamic> data,
    required BuildContext context,
  }) async
  {
    try {
      dynamic response = await restClient.post(APIType.protected,
          data,
          path: "$baseUrl/${ApiEndpoint.notifyUser}",
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
