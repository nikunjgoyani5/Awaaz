import 'dart:async';
import 'dart:developer';

import 'package:eagle_eye_admin/api/repository/user_manage_repository.dart';
import 'package:eagle_eye_admin/model/get_all_user_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserManagementController extends GetxController {

  TextEditingController searchController = TextEditingController();

  RxBool loader = false.obs;
  RxBool paginationLoader = false.obs;
  int pageNumber = 1;

  double selectedSubTab = 4.1;

  Timer? debounce;

  List<UserData> usersList = [];
  GetAllUsers getAllUsersModel = GetAllUsers();

  userPagination({    required BuildContext context,}) async {
    paginationLoader.value = true;
    pageNumber++;
    await getUsersAPI(context: context);
    update();
  }

  Future getUsersAPI({String? searchText,     required BuildContext context,}) async {
    try {
      loader.value = paginationLoader.value == true ? false : true;
      ResponseModel res = await UserManageRepository.getAllUsers(
        context: context,
        type: selectedSubTab == 4.1 ? 'all' : 'block',
        page: pageNumber.toString(),
        search: searchText??''
      );
      if (res.status == true) {
        getAllUsersModel = GetAllUsers.fromJson(res.toJson());
        usersList = usersList + (getAllUsersModel.body?.data ?? []);
        update();
        log('All  Users :- $usersList');
      } else {
        usersList = usersList;
        log('Get  Users :- ${res.message}');
      }
      paginationLoader.value = false;
      loader.value = false;
    } catch (e) {
      usersList = usersList;

      paginationLoader.value = false;
      loader.value = false;
      log('Get  Users  :- $e');
    }
  }




  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }
}
