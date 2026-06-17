import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as test;
import 'package:dio/dio.dart';
import 'package:eagle_eye_admin/api/repository/user_repository.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/controller/report_controller.dart';
import 'package:eagle_eye_admin/controller/user_management_controller.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/model/search_location_model.dart';
import 'package:eagle_eye_admin/model/update_profile_model.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/location_utils.dart';
import 'package:eagle_eye_admin/widget/dailoges.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';

class DashboardController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController locationSearchController =
      TextEditingController();
  TextEditingController distanceController = TextEditingController();

  int selectedTab = 0;
  double selectedSubTab = 0;
  bool isHoverdOnEventPost = false;
  bool isOpenReportDropdown = false;
  bool isOpenUserManageDropdown = false;

  RxBool locationLoader = false.obs;

  SearchedAddress? selectedLocation;

  int selectedIndex = 0;

  List<SearchedAddress> filteredLocationList = [];

  double radiusValue = 50.00;
  double selectedRadiusValue = 50.00;
  String locationMessage = '';

  Timer? debounce;

  XFile? selectedImageOrVideo;
  XFile? selectedFile;
  Uint8List? selectedImageOrVideoBytes;

  XFile? thumbnailImage;
  Uint8List? thumbnailImageBytes;

  Future<XFile?> pickMedia(MediaType mediaType) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    if (mediaType == MediaType.image) {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    } else if (mediaType == MediaType.video) {
      pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      String filePath = pickedFile.path;
      log("${mediaType == MediaType.image ? 'Image' : 'Video'} selected: $filePath");

      if (mediaType == MediaType.video) {
        try {
          XFile? thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: filePath,
            quality: 75,
          );
          update();
          log("Thumbnail generated: $thumbnailPath");
        } catch (e) {
          log("Error generating thumbnail: $e");
        }
      } else if (mediaType == MediaType.image) {
        log("Image picked successfully.");
      }
      return pickedFile;
    } else {
      log("No ${mediaType == MediaType.image ? 'image' : 'video'} selected.");
    }
    return null;
  }

  openVideoOrImageDailoge({required BuildContext context}) async {
    showDialog(
      // barrierDismissible: false,
      context: context,
      routeSettings: const RouteSettings(name: '/event/videoOrImage'),
      builder: (context) {
        return PhotoOrVideoOptionDailoge(
          isVideoHide: true,
          onPhotoTap: () async {
            selectedImageOrVideo = await pickMedia(MediaType.image);
            selectedImageOrVideoBytes =
                await selectedImageOrVideo!.readAsBytes();
            thumbnailImage = selectedImageOrVideo;
            thumbnailImageBytes = await selectedImageOrVideo!.readAsBytes();
            update();
            NavigatorRoute.navigateBack(context: context);
          },
        );
      },
    );
  }

  fetchAdminCurrentLocation() async {
    await LocationUtils.fetchLocation();
    if (LocationUtils.position != null) {
      locationSearchController.text =
          LocationUtils.placemark?.street.toString() ?? '';
      update();
    }
  }

  TextEditingController adminNameController = TextEditingController();

  Future<void> getCurrentLocation() async {
    EventController eventController = Get.find();

    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationMessage = 'Location services are disabled.';
      log("======888888====$locationMessage");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationMessage = 'Location permissions are denied';
        log("======888888====$locationMessage");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationMessage =
          'Location permissions are permanently denied, we cannot request permissions.';
      log("======888888====$locationMessage");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    locationMessage =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    log("======888888====$locationMessage");
    eventController.longitude = position.longitude;
    eventController.latitude = position.latitude;

    StorageService.saveLatitude(position.latitude);
    StorageService.saveLongitude(position.longitude);
    StorageService.saveCurrentLatitude(position.latitude);
    StorageService.saveCurrentLongitude(position.longitude);

    String address =
        await getAddressFromLatLngOSM(position.latitude, position.longitude) ??
            '';
    StorageService.saveCurrentAddress(address);
    StorageService.saveAddress(address);
  }

  Future<String?> getAddressFromLatLngOSM(double lat, double lng) async {
    String url =
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng";
    var dio = Dio();
    var response = await dio.request(
      url,
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      var data = response.data;
      debugPrint(
          'Current loc: ----${data["address"]['city'] ?? ""} ${data["address"]['country'] ?? ''}');
      return "${data["address"]['city'] ?? ""} ${data["address"]['country'] ?? ''}";
    }
    return null;
  }

  Future<void> searchAddress(String searchQuery, BuildContext context) async {
    locationLoader.value = true;
    try {
      var headers = {
        'Authorization': 'prj_live_pk_e6cc102efc32ced4de39e61566b1c17cf1449697'
      };
      var dio = Dio();
      var response = await dio.request(
        'https://api.radar.io/v1/search/autocomplete?query=$searchQuery&layers=place%2Cstreet%2Cneighborhood%2CpostalCode%2Clocality&limit=15',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        String data = json.encode(response.data);
        SearchLocationModel searchLocationModel =
            searchLocationModelFromJson(data);

        filteredLocationList = searchLocationModel.addresses ?? [];
        update();
      } else {
        log('${response.statusMessage}');
      }
    } catch (e) {
      locationLoader.value = false;
      log('Error getting location: $e');
    }
    locationLoader.value = false;
  }

//   @override
//   void onReady() {
//     UserManagementController userController =
//         Get.put(UserManagementController());
//     ReportController reportController = Get.put(ReportController());
//
//     selectedTab = StorageService.getSelectedTab();
//     if (selectedTab == 2) {
//
//       isOpenReportDropdown = true ;
//       reportController.selectedSubTab = StorageService.getSubSelectedTab();
//
//
//     } else if (selectedTab == 3) {
//       isOpenUserManageDropdown = true;
//       userController.selectedSubTab = StorageService.getSubSelectedTab();
//
//       userController.searchController.clear();
//       userController.usersList.clear();
//       userController.pageNumber = 1;
//        userController.getUsersAPI(context: context);
//     } else {
//
//     }
// update();
//
//
//     super.onReady();
//   }

  onRefresh(BuildContext context) {
    UserManagementController userController =
        Get.put(UserManagementController());
    ReportController reportController = Get.put(ReportController());

    selectedTab = StorageService.getSelectedTab();

    if (selectedTab == 2) {
      isOpenReportDropdown = true;
      reportController.selectedSubTab = StorageService.getSubSelectedTab();
    } else if (selectedTab == 3) {
      isOpenUserManageDropdown = true;
      userController.selectedSubTab = StorageService.getSubSelectedTab();
      userController.searchController.clear();
      userController.usersList.clear();
      userController.pageNumber = 1;
      userController.getUsersAPI(context: context);
    } else {}
    // update();
  }

  Future getAdminProfile() async {}
  ResponseModel res = ResponseModel(status: false, body: {}, message: '');

  updateAdminProfile(BuildContext context, ProgressLoader pl) async {
    try {
      await pl.show();
      Uint8List? attachmentByte;
      if (selectedImageOrVideo != null) {
        attachmentByte = await selectedImageOrVideo!.readAsBytes();
      }

      var data = {
        if (adminNameController.text.isNotEmpty)
          'name': adminNameController.text,
        if (selectedImageOrVideo != null)
          'profilePicture': test.MultipartFile.fromBytes(
            attachmentByte ?? Uint8List(0),
            filename: selectedImageOrVideo!.name,
          ),
      };

      res =
          await UserRepository.updateAdminProfile(context: context, data: data);
      await pl.hide();
      if (res.status == true) {
        UpdateProfileModel adminProfileData =
            UpdateProfileModel.fromJson(res.toJson());
        StorageService.saveProfilePic(
            adminProfileData.body?.profilePicture ?? "");
        StorageService.saveName(adminProfileData.body?.name ?? "");
        update();

        selectedImageOrVideo = null;
        selectedImageOrVideoBytes = null;
        adminNameController.clear();
        NavigatorRoute.navigateBack(context: context);
        showToast(
            context: context, title: 'User profile', message: res.message);
      } else {
        showToast(
            context: context,
            title: 'User profile',
            message: res.message,
            bgColor: AppColors.red);
      }
      await pl.hide();
    } catch (e) {
      await pl.hide();
      log('User profile:- $e');
    }
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future init() async {
    await getCurrentLocation();
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }
}
