import 'dart:developer';
import 'package:dio/dio.dart' as test;
import 'package:eagle_eye_admin/api/repository/event_repository.dart';
import 'package:eagle_eye_admin/api/repository/general_repository.dart';
import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/controller/general_controller.dart';
import 'package:eagle_eye_admin/model/categories_model.dart';
import 'package:eagle_eye_admin/model/get_single_general_model.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';

import '../api/repository/reaction_and_category_repository.dart';

class GeneralDetailController extends GetxController {



  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController hashController = TextEditingController();

GlobalKey<FormState>  formKey = GlobalKey<FormState>();

ScrollController generalDetailScrollController= ScrollController();
  TextEditingController categorySearchController = TextEditingController();

XFile? postFirstFile;

XFile? postFirstFileThumbnail;

Uint8List? postFirstFileBytes;

onPickFirstPostVideo() async {
  ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  pickedFile = await picker.pickVideo(source: ImageSource.gallery);

  if (pickedFile != null) {
    XFile? thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: pickedFile.path,
      quality: 75,
    );
    postFirstFile = pickedFile;
    postFirstFileThumbnail = thumbnailPath;
    postFirstFileBytes = await thumbnailPath.readAsBytes();
  }
  update();
}

  getAllCategories({
    required BuildContext context,
  })

  async
  {
    try {

      ResponseModel res = await ReactionAndCategoryRepository.getAllCategories(
   postType: 'general_category',
          context: context);
      if (res.status == true) {
        CategoriesModel categoriesModel =
        CategoriesModel.fromJson(res.toJson());
        generalCategoryList.clear();
        generalCategoryList.addAll(categoriesModel.body!);
        update();
        log('All Categories :- $generalCategoryList');
      } else {
        log('Get All Categories :- ${res.message}');
      }

    } catch (e) {

      log('Get All Categories :- $e');

    }
  }

  onRefresh({
    required BuildContext context,
  }) async {

    Get.put(GeneralController());
    DashboardController dashboardController = Get.put(DashboardController());
    dashboardController.selectedTab = 5;
    StorageService.saveSelectedTab(5);

    await getAllCategories(context: context);

    await getSingleGeneral(StorageService.getEventId() ?? '',context: context);



  }

  RxBool detailLoader = false.obs;

  GetSingleGeneralData getSingleGeneralData = GetSingleGeneralData();
  Future<void> getSingleGeneral(String eventId,
      {required BuildContext context}) async
  {
    try {
      detailLoader.value = true;
      ResponseModel res = await EventRepository.getSingleEvent(
          context: context, postType: 'general_category', id: eventId);

      if (res.status == true) {
        GetSingleGeneralModel getSingleGeneralModel =
        GetSingleGeneralModel.fromJson(res.toJson());

        getSingleGeneralData =
            getSingleGeneralModel.body ?? GetSingleGeneralData();


        setGeneralEventData();

      } else {
        log('Get single general :- $res');
      }
      update();

      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log('Get single general :- $e');
    }
  }

  Categorie? selectedCategory;
  SubCategory? selectedSubCategory;


  List<Categorie> generalCategoryList =[];
  List<SubCategory> subCategoryList =[];
  setGeneralEventData() {
    subCategoryList.clear();
    titleController.text = getSingleGeneralData.title ?? '';
    desController.text = getSingleGeneralData.description ?? '';
    addressController.text = getSingleGeneralData.address ?? '';
    latController.text = getSingleGeneralData.latitude?.toString() ?? '';
    longController.text = getSingleGeneralData.longitude?.toString() ?? '';
    hashController.text = getSingleGeneralData.hashTags
        ?.toString()
        .replaceAll('[', '')
        .replaceAll(']', '') ??
        '';


    for (var element in generalCategoryList) {
      if (element.id == getSingleGeneralData.mainCategoryId) {
        selectedCategory = element;
      }
    }

    subCategoryList.addAll(selectedCategory?.subCategories??[]);

    for (var element in subCategoryList) {
      if (element.id == getSingleGeneralData.subCategoryId) {
        selectedSubCategory = element;
      }
    }

    update();
  }
  List<String> extractHashtags(String input) {
    final RegExp hashtagRegExp = RegExp(r'#[\w]+');
    return hashtagRegExp
        .allMatches(input)
        .map((match) => match.group(0)!)
        .toList();
  }
  updateGeneralAPI(BuildContext context, ProgressLoader pl) async {

    GeneralController generalController = Get.find();
    if (selectedCategory == null) {
      showToast(
          context: context,
          title: 'General Post!',
          message: 'Please select General Post category',
          bgColor: AppColors.red);
      return;
    }else if (selectedSubCategory == null) {
      showToast(
          context: context,
          title: 'General Post!',
          message: 'Please select sub category',
          bgColor: AppColors.red);
      return;
    }

    else if (formKey.currentState?.validate() == true) {
      try {
        List hashTags = [];
        if (hashController.text.isNotEmpty) {
          hashTags = extractHashtags(hashController.text);
        }

        await pl.show();
        Uint8List? attachmentByte;

        if (postFirstFile != null) {
          attachmentByte = await postFirstFile!.readAsBytes();
        }

        var data = {
          'eventPostId': getSingleGeneralData.id,
          'postType': 'general_post',
          'latitude': num.parse(latController.text),
          'longitude': num.parse(longController.text),
          'title': titleController.text,
          if(desController.text.isNotEmpty)
            'description': desController.text,

          if(addressController.text.isNotEmpty)
            'address': addressController.text,

          'mainCategoryId': selectedCategory?.id ?? '',
          'subCategoryId': selectedSubCategory?.id ?? '',
          'hashTags[]': hashTags,

          if (postFirstFile != null)
            'gallaryAttachment': test.MultipartFile.fromBytes(
                attachmentByte ?? Uint8List(0),
                filename: postFirstFile!.name),
          if (postFirstFileThumbnail != null)
            'gallaryThumbnail': test.MultipartFile.fromBytes(
                postFirstFileBytes ?? Uint8List(0),
                filename: 'thumbnail.png'),
        };

        ResponseModel res =
        await GeneralPostRepository.updateGeneralPost(context: context, data: data);
        await pl.hide();
        if (res.status == true) {
          NavigatorRoute.navigateBack(context:  context);

          generalController.filterGeneralList.clear();
          generalController.pageNumber = 1;
          generalController.generalSearchController.clear();
          await generalController.getGeneralPostList(context: context);
          showToast(context: context, title: 'Success', message: res.message);
        } else {
          showToast(
              context: context,
              title: 'Error',
              message: res.message,
              bgColor: AppColors.red);
        }
      } catch (e) {
        await pl.hide();
        log(' $e');
      }
    }
  }

  Future<void> deletePostApiCalling(
      String eventId, BuildContext context) async
  {
    try {
      GeneralController generalController = Get.find();
      detailLoader.value = true;
      ResponseModel res = await EventRepository.deleteEvent(id: eventId,context: context);

      if (res.status == true) {
        NavigatorRoute.navigateBack(context:  context);
        showToast(context: context, title: 'General Post', message: res.message);
        generalController.filterGeneralList.clear();
        generalController.pageNumber = 1;
        generalController.generalSearchController.clear();
        await generalController.getGeneralPostList(context: context);
      } else {
        showToast(
            context: context,
            title: 'General Post',
            message: res.message,
            bgColor: AppColors.red);
        log(' General Post delete  :- $res');
      }
      update();
      detailLoader.value = false;
    } catch (e) {
      detailLoader.value = false;
      log(' General Post delete :- $e');
    }
  }

}