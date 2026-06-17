import 'dart:developer';

import 'package:eagle_eye_admin/api/repository/super_admin_repository.dart';
import 'package:eagle_eye_admin/model/admin_list_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuperAdminController extends GetxController {
  AllAdminModel allAdminModel = AllAdminModel();
  List<AdminList> filteredAdminList = [];
  int selectedTab = 0;
  String status = 'Pending';
  RxBool loader = false.obs;

  int pageNumber = 1;
  RxBool paginationLoader = false.obs;

  adminPagination({    required BuildContext context,}) async {
    paginationLoader.value = true;
    pageNumber++;
   await  fetchAdminList(context: context);
    update();
  }


  onChangeTab(int index,{    required BuildContext context,}) async {
    selectedTab = index;
    filteredAdminList.clear();
    pageNumber=1;
    await fetchAdminList(context: context);
    update();
  }

  Future fetchAdminList({    required BuildContext context,}) async {
    try {
      loader.value = paginationLoader.value == true ? false : true;
      ResponseModel? res = await SuperAdminRepository.getAllAdmins(
        context: context,
          page: pageNumber.toString(),
          status: selectedTab == 0
              ? 'Pending'
              : selectedTab == 1
                  ? 'Approved'
                  : 'Rejected');
      if (res.status == true) {
        allAdminModel = AllAdminModel.fromJson(res.toJson());


        filteredAdminList=filteredAdminList +  (allAdminModel.body?.data ?? []);
        update();
        log('All Admin :- $filteredAdminList');
      } else {
        filteredAdminList=filteredAdminList;
        log('Get All Admin :- ${res.message}');
      }
      update();
      paginationLoader.value = false;
      loader.value = false;
    } catch (e) {
      filteredAdminList=filteredAdminList;
      paginationLoader.value = false;
      loader.value = false;
      log('Get All Admin :- $e');
    }
  }

  Future adminStatusUpdateAPI(
      {required String adminId,
      required String status,
      required BuildContext context}) async {
    try {
      loader.value = true;

      ResponseModel res = await SuperAdminRepository.adminStatusChange(
        context: context,
          registerAdminId: adminId, status: status);

      if (res.status == true) {
        await showToast(
            title: 'Admin Status',
            message: 'Status updated successfully',
            context: context);
        filteredAdminList.clear();
        pageNumber=1;
       await fetchAdminList(context: context);


      } else {
        showToast(
            title: 'Admin Status',
            message: res.message,
            bgColor: AppColors.red,
            context: context);
        log('Admin status :- $res');
      }
      update();
      loader.value = false;
    } catch (e) {
      loader.value = false;
      log(' Admin Status :- $e');
    }
  }

  @override
  void onInit() {
    // init();
    super.onInit();
  }

  init({    required BuildContext context,}) async {
    filteredAdminList.clear();
    pageNumber=1;
    await fetchAdminList(context: context);
  }
}
