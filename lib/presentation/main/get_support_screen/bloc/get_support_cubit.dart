import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_functions.dart';
import '../../../../core/widget/common_bottom_sheet.dart';
import '../../../../data/models/get_supports_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';
import '../../../../routes/app_navigation.dart';
import '../../../../services/file_service.dart';

part 'get_support_cubit.freezed.dart';
part 'get_support_state.dart';

class GetSupportCubit extends Cubit<GetSupportState> {

  GetSupportCubit() : super(const GetSupportState());

  init() {
    emit(state.copyWith(
      isLoading: false,
      emailController: TextEditingController(),
      descriptionController: TextEditingController(),
      subjectController: TextEditingController(),
      file: null,
    ));
  }

  updateCurrentIndex(int value) {
    emit(state.copyWith(selectedSupportIndex: value));
  }

  Future<void> getSupportTicketList() async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.getSupportList(
          state.selectedSupportIndex == 0 ? 'open' : 'close');
      if (response.status == true && response.body != null) {
        GetSupportModel getSupportModel =
            GetSupportModel.fromJson(response.toJson());
        List<SupportData> tempList = getSupportModel.data ?? [];
        emit(state.copyWith(
          isLoading: false,
          supportDataList: tempList,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  //Get Profile picture
  Future onTapProfile(BuildContext context) async {
    await showAppBottomSheet(
        context,
        AppCommonBottomSheet(
            isOpenWithGradient: false,
            body: ImagePickerWidget(
              callback: (PickerMode pickerMode) async {
                String? res = await FileService.pickFile(pickerMode);
                NavigatorRoute.navigateBack(context);
                if (res != null) {
                  emit(state.copyWith(file: File(res)));
                }
              },
            )));
  }

  Future<void> validateField(BuildContext context) async {
    if (state.emailController!.text.isEmpty) {
      AppFunctions.showToast('Please enter email');
    } else if (!AppFunctions.checkEmailValidation(
        state.emailController!.text.trim())) {
      AppFunctions.showToast('Please enter valid email');
    } else if (state.subjectController!.text.isEmpty) {
      AppFunctions.showToast('Please enter subject');
    } else {
      await addSupportRequest(context);
    }
  }

  Future<void> addSupportRequest(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.addSupport(data: {
        'email': state.emailController!.text,
        'subject': state.subjectController!.text,
        'description': state.descriptionController!.text,
        if (state.file?.path != null && state.file?.path != "")
          "attachments": await MultipartFile.fromFile(state.file?.path ?? ''),
      });
      if (response.status == true) {
        emit(state.copyWith(isLoading: false));
        await getSupportTicketList();
        NavigatorRoute.navigateBack(context);
        AppFunctions.showToast(response.message);
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }
}
