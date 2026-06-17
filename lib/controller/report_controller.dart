import 'dart:developer';

import 'package:eagle_eye_admin/api/repository/event_repository.dart';
import 'package:eagle_eye_admin/api/repository/report_repository.dart';
import 'package:eagle_eye_admin/model/reported_comments_model.dart';
import 'package:eagle_eye_admin/model/reported_post_model.dart';
import 'package:eagle_eye_admin/model/reported_users_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  double selectedSubTab = 0;
  List<ReportedPost> reportedPostList = [];
  List<ReportedComments> reportedCommentsList = [];
  List<ReportedUser> reportedUsersList = [];
  RxBool loader = false.obs;

  Future getReportedPosts({    required BuildContext context,}) async {
    try {
      loader.value = true;
      ResponseModel res = await ReportRepository.getAllReportedPost(context: context);
      if (res.status == true) {
        GetAllReportedPost reportModel =
            GetAllReportedPost.fromJson(res.toJson());

        reportedPostList = reportModel.body ?? [];
        update();
        log('All Reported Post :- $reportedPostList');
      } else {
        log('Get Reported Post :- ${res.message}');
      }
      loader.value = false;
    } catch (e) {
      loader.value = false;
      log('Get Reported Post  :- $e');
    }
  }

  Future getReportedComments({required BuildContext context,}    ) async {
    try {
      loader.value = true;
      ResponseModel res = await ReportRepository.getAllReportedComments(context: context);
      if (res.status == true) {
        GetAllReportedComments reportedComments =
            GetAllReportedComments.fromJson(res.toJson());

        reportedCommentsList = reportedComments.body?.data ?? [];
        update();
        log('All Reported Comments :- $reportedPostList');
      } else {
        log('Get Reported Comments :- ${res.message}');
      }
      loader.value = false;
    } catch (e) {
      loader.value = false;
      log('Get Reported Comments  :- $e');
    }
  }

  Future getReportedUsers({required BuildContext context,}) async {
    try {
      loader.value = true;
      ResponseModel res = await ReportRepository.getAllReportedUser(context: context);
      if (res.status == true) {
        GetAllReportedUsers reportedUsers =
            GetAllReportedUsers.fromJson(res.toJson());

        reportedUsersList = reportedUsers.body ?? [];
        update();
        log('All Reported Users :- $reportedPostList');
      } else {
        log('Get Reported Users :- ${res.message}');
      }
      loader.value = false;
    } catch (e) {
      loader.value = false;
      log('Get Reported Users  :- $e');
    }
  }

  Future userBlockAPICalling({
    required ProgressLoader pl,
    required String userId,
    required BuildContext context,
  })
  async {
    try {
      await pl.show();
      ResponseModel res =
          await ReportRepository.userBlockUnblock(userId: userId,context: context);
      if (res.status == true) {
        showToast(context: context, title: 'User', message: res.message);
        update();

        log('Block unblock Users :- $reportedPostList');
        await getReportedUsers(context: context);
      } else {
        showToast(
            context: context,
            title: 'User',
            message: res.message,
            bgColor: AppColors.red);
        log('Block unblock Users:- ${res.message}');
      }
      await pl.hide();
    } catch (e) {
      showToast(
          context: context,
          title: 'User',
          message: 'Something went wrong!',
          bgColor: AppColors.red);

      await pl.hide();
      log('Block unblock Users:- $e');
    }
  }

  Future<void> deletePostApiCalling(
      {required String postId,
      required BuildContext context,
      required ProgressLoader pl}) async {
    try {
      await pl.show();
      ResponseModel res = await EventRepository.deleteEvent(id: postId,context: context);

      if (res.status == true) {
        showToast(context: context, title: 'Post', message: res.message);
        await getReportedPosts(context: context);
      } else {
        showToast(
            context: context,
            title: 'Event',
            message: res.message,
            bgColor: AppColors.red);
        log(' Post delete  :- $res');
      }
      update();
      await pl.hide();
    } catch (e) {
      await pl.hide();
      log(' Post delete :- $e');
    }
  }

  Future<void> deleteCommentApi(
      {required String commentId,
      required BuildContext context,
      required ProgressLoader pl,
      required String postId,
      required String reportId}) async {
    try {

      Map<String,dynamic> commentData ={


        "reportType": "comment",
        "postId": postId,
        "commentId": commentId,
        // "commentReplyId": "",
        "reportId": reportId,
      };

      await pl.show();
      ResponseModel res =
      await ReportRepository.deleteCommentAPI(data: commentData, context: context);

      if (res.status == true) {
        showToast(context: context, title: 'Comment', message: res.message);
      } else {
        showToast(
            context: context,
            title: 'Comment',
            message: res.message,
            bgColor: AppColors.red);
        log(' Comment delete  :- $res');
      }
      update();
      NavigatorRoute.navigateBack(context:  context);
      NavigatorRoute.navigateBack(context:  context);
      await getReportedComments(context: context);
      await pl.hide();
    } catch (e) {
      await pl.hide();
      log(' Comment delete :- $e');
    }
  }

  Future init({required BuildContext context,}) async {
    await getReportedPosts(context: context);
    await getReportedComments(context: context);
    await getReportedUsers(context: context);
  }
}
