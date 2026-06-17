import 'package:eagle_eye_admin/controller/app_controller.dart';
import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/update_admin_profile_dialog.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/utils/responsive_utils.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class Header extends StatefulWidget {
  const Header({
    super.key,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return Container(
        height: 85.h,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.borderColor, width: 3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: appController.controlMenu,
              ),
            if (!Responsive.isMobile(context))
              SizedBox(
                height: 60,
                width: 400,
                child: CommonTextField(
                  prefixIcon: SizedBox(
                      height: 50,
                      width: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Assets.icons.icSearch.svg(),
                      )),
                  height: 45,
                  fillColor: AppColors.borderColor,
                  enableBorderColor: AppColors.borderColor,
                  hintText: "Search",
                  controller: controller.searchController,
                ),
              ),
            if (!Responsive.isMobile(context))
              Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            const ProfileCard()
          ],
        ),
      );
    });
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return Container(
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16 / 2,
        ),
        child: Row(
          children: [
            if (!Responsive.isMobile(context))
              IconButton(
                onPressed: () {
                  // StorageService.clearStorage();
                  commonDialog(
                    context: context,
                    subtitle: 'Are you sure want to logout?',
                    title: 'Log out',
                    onTap: () async {
                      String email = StorageService.getEmail() ?? '';
                      String pass = StorageService.getPass() ?? '';
                      bool isSaved =
                          StorageService.getIsSaveCredentials() ?? false;

                      StorageService.clearStorage();

                      StorageService.savePass(pass);
                      StorageService.saveEmail(email);
                      StorageService.saveCredentials(isSaved);
                      context.go(AppRoutes.login);
                      // Get.offAll(() => const LoginScreen());
                    },
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16 / 2),
              child: Text(
                StorageService.getName() ?? 'Awaaz',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.w500),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const UpdateAdminProfileDialog();
                  },
                );
              },
              child: ClipOval(
                child: AppNetworkImageLoader(
                  url: StorageService.getProfilePic() ?? '',
                  height: 30,
                  width: 30,
                  boxFit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
