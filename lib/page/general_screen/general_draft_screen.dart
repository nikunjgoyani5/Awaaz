import 'package:eagle_eye_admin/controller/general_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/header.dart';
import 'package:eagle_eye_admin/page/general_screen/component/general_draft_card_view.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GeneralDraftScreen extends StatefulWidget {
  const GeneralDraftScreen({super.key});

  @override
  State<GeneralDraftScreen> createState() => _GeneralDraftScreenState();
}

class _GeneralDraftScreenState extends State<GeneralDraftScreen> {
  GeneralController generalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(initState: (state) async {
      await generalController.getGeneralDraftList(context: context);
    }, builder: (controller) {
      return Expanded(
        flex: 5,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.image.mapBg.path,
              ),
              fit: BoxFit.contain,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.selectedSubTab = 5.1;
                        controller.update();
                        setState(() {});
                        NavigatorRoute.navigateToSpecificPage(
                            AppRoutes.event, context);
                      },
                      child: ClipOval(
                        child: Container(
                          color: Colors.white24,
                          height: 45,
                          width: 45,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Gap(20.w),
                    Text(
                      'General Drafts',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white),
                    ),
                    const Spacer(),
                    const ProfileCard(),
                  ],
                ),
              ),
              const Gap(30),
              Expanded(
                  child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 300.w),
                      child: Column(
                        children: [
                          Obx(
                                () {
                              return generalController.draftLoader.value == true
                                  ? Column(children: [
                                Gap(MediaQuery.of(context).size.height* 0.4),
                                const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              ])
                                  :

                              controller.draftList.isNotEmpty?
                              ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    Gap(10.h),
                                itemCount: controller.draftList.length,
                                itemBuilder: (context, index) {

return
  GeneralDraftCardView(
    index: index,
      draftData: controller.draftList[index],

                                    );
                                },
                              )
                                  : Column(
                                children: [
                                  Gap(MediaQuery.of(context).size.height* 0.4),
                                  Text(
                                    'No Drafts Found',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        fontWeight:
                                        FontWeight.w600,
                                        color:
                                        AppColors.white),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ))),
              const Gap(30),
            ],
          ),
        ),
      );
    });
  }
}
