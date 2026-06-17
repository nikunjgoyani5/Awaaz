import 'package:eagle_eye_admin/controller/rescue_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/page/dashboard_screen/components/header.dart';
import 'package:eagle_eye_admin/page/rescue_screen/component/rescue_draft_card_view.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RescueDraftScreen extends StatefulWidget {
  const RescueDraftScreen({super.key});

  @override
  State<RescueDraftScreen> createState() => _RescueDraftScreenState();
}

class _RescueDraftScreenState extends State<RescueDraftScreen> {
  RescueController rescueController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RescueController>(initState: (state) async {
      await rescueController.getRescueDraftList(context: context);
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
                        controller.selectedSubTab = 2.1;
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
                      'Rescue Drafts',
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
                              return rescueController.draftLoader.value == true
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
                                    controller.draftList[index].postType=='rescue'?

                                    RescueDraftCardView(
                                      index: index,
                                      draftData: controller.draftList[index] ,
                                    ): const SizedBox();
                                },
                              ) :
                              Column(
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
