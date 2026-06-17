import 'package:eagle_eye_admin/controller/general_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_filter_general_post.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';

import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';

import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GeneralPostCardView extends StatefulWidget {
  const GeneralPostCardView({super.key, required this.index, required this.filterGeneral});

  final int index;
  final FilterGeneral filterGeneral;

  @override
  State<GeneralPostCardView> createState() => _GeneralPostCardViewState();
}

class _GeneralPostCardViewState extends State<GeneralPostCardView> {
  GeneralController controller = Get.put(GeneralController());

  String convertTime(String utcDate) {
    DateTime utcDateTime = DateTime.parse(utcDate);

    DateTime localDateTime = utcDateTime.toLocal();

    String formattedTime = DateFormat("dd/MM/yyyy hh:mm a").format(localDateTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (controller) {
      return InkWell(
        focusColor: AppColors.transparent,
        overlayColor: WidgetStateProperty.all(AppColors.transparent),
        radius: 0,
        onTap: () async {


          if (widget.filterGeneral.status == 'Pending') {

          } else if (widget.filterGeneral.status == 'Approved') {


            controller.selectedCategory = null;
            StorageService.saveEventId(widget.filterGeneral.id ?? "");
            await NavigatorRoute.navigateTo(AppRoutes.generalDetails, context,
                arguments: widget.filterGeneral.id);
          } else if (widget.filterGeneral.status == 'Rejected') {

          }
          controller.update();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.eventCardBgColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      radius: 0,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return  UserProfileView(
                              userId: widget.filterGeneral.userId??"",
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                           ClipOval(
                            child: AppNetworkImageLoader(
                              url: widget.filterGeneral.profilePicture ?? "",
                              height: 40,
                              width: 40,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                          // Image.network( widget.filterGeneral.profilePicture
                          // , height: 50,width: 50,
                          //   fit: BoxFit.contain,
                          // ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16 / 2),
                            child: Text(
                              widget.filterGeneral.name ?? (StorageService.getName() ?? ''),

                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff1C7EFF)
                                  .withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: Text(
                                '${widget.filterGeneral.mainCategory?.eventName??''} / ${widget.filterGeneral.subCategory?.eventName??''}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: const Color(0xff1C7EFF),
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Gap(20.w),
                    Row(
                      children: [
                        Assets.icons.icWatch.svg(),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16 / 2),
                          child: Text(
                            (widget.filterGeneral.eventTime?.isNotEmpty ?? false)
                                ? convertTime(widget.filterGeneral.eventTime ?? "")
                                : '',

                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!

                                .copyWith(
                                    color: AppColors.grey929da9,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (widget.filterGeneral.attachmentFileType == 'Video') {

                          showDialog(
                            context: context,
                            routeSettings: const RouteSettings(name: '/event/eventPreview'),
                            builder: (context) {
                              return EventPreviewDailoge(
                                  videoPath:widget.filterGeneral.attachment ?? ''
                              );
                            },
                          );

                        } else if (widget.filterGeneral.attachmentFileType == 'Image') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return  EventImagePreviewDialog(
                                imageURL: widget.filterGeneral.attachment ?? '',
                              );
                            },
                          );


                        } else {


                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),

                                border:widget.filterGeneral.thumbnail== null? Border.all(color: AppColors.white, width: 1): null,
                              ),
                              child: Image.network(
                                  widget.filterGeneral.thumbnail ?? '',
                                  height:
                                      MediaQuery.of(context).size.height * 0.098,
                                  width:
                                      MediaQuery.of(context).size.height * 0.098,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                return AppImageViewer.showAssetImage(
                                  path: Assets.image.noDataSelected.path,
                                  height:
                                      MediaQuery.of(context).size.height * 0.098,
                                  width:
                                      MediaQuery.of(context).size.height * 0.098,
                                  boxFit: BoxFit.cover,
                                );
                              }),
                            ),
                          ),


                          widget.filterGeneral.attachmentFileType == 'Video'?     Container(

                            child: Assets.icons.icPlay.svg(
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ): const SizedBox()
                        ],
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.filterGeneral.title??"",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700),
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.filterGeneral.description ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            (widget.filterGeneral.address?.isNotEmpty ?? false)?     Assets.icons.icLocation.svg(): const SizedBox() ,
                            Expanded(
                              child: Text(
                                widget.filterGeneral.address??"",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: AppColors.grey929da9,
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                            Gap(10.w),
                            /*   widget.filterGeneral.status == 'Pending'
                                    ? SizedBox(
                                  width: 180.w,
                                  height: 40.h,
                                  child: CommonButton(
                                      color: AppColors.borderColor,
                                      radius: 5,
                                      widget: Text(
                                        'Quick approve',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                            color: AppColors.golden,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                      onPressed: () async {
                                        // controller.selectedEvent =
                                        //     widget.filterGeneral;
                                        // controller.setCreateEventData();
                                        //
                                        // await controller.createQuickEvent(
                                        //     context, pl, true);
                                      }),
                                )

                                    :*/
                            widget.filterGeneral.status == 'Pending'
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 130.w,
                                        height: 45.h,
                                        child: CommonButton(
                                            color: AppColors.borderColor,
                                            radius: 5,
                                            widget: Text(
                                              'Reject',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color:
                                                          AppColors.grey929da9,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            onPressed: () async {
                                              commonDialog(
                                                context: context,
                                                subtitle:
                                                    'Are you sure want to reject?',
                                                title: 'Disapprove',
                                                onTap: () async {
                                                  NavigatorRoute.navigateBack(
                                                      context: context);
                                                  await controller
                                                      .statusUpdateAPI(
                                                      status: 'Rejected',
                                                      context: context,
                                                      postId:
                                                      widget.filterGeneral.id ??
                                                          '',
                                                      isNotify: true);
                                                },
                                              );
                                            }),
                                      ),
                                      const Gap(20),
                                      SizedBox(
                                        width: 130.w,
                                        height: 45.h,
                                        child: CommonButton(
                                            color: AppColors.white,
                                            radius: 5,
                                            widget: Text(
                                              'Approve',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            onPressed: () async {



                                              controller.clearGeneralData();
                                              controller.selectedGeneral =
                                                  widget.filterGeneral;



                                              await controller
                                                  .openAddGeneralDialog(
                                                      true, context);
                                            }),
                                      )
                                    ],
                                  )
                                : widget.filterGeneral.status == 'Approved'
                                    ? SizedBox(
                                        width: 120.w,
                                        height: 45.h,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.green
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Text(
                                            'Approved',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: AppColors.green,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          commonDialog(
                                            context: context,
                                            subtitle:
                                                'Are you sure want to roll back disapproved post?',
                                            title: 'Roll back post',
                                            onTap: () async {
                                              NavigatorRoute.navigateBack(
                                                  context: context);
                                              await controller
                                                  .statusUpdateAPI(
                                                  status: 'Pending',
                                                  context: context,
                                                  postId: controller
                                                      .filterGeneralList[
                                                  widget
                                                      .index]
                                                      .id ??
                                                      '',
                                                  isNotify: false);
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 45.h,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.red
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Text(
                                            'Rejected',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: AppColors.red,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                      )
                          ],
                        ),
                      ],
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
