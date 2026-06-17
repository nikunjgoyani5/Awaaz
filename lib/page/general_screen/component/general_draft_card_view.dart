import 'package:eagle_eye_admin/controller/general_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_event_drafts_model.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/page/general_screen/component/add_new_general_dialog.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/utils/app_image_viewer.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GeneralDraftCardView extends StatefulWidget {
  const GeneralDraftCardView(
      {super.key, required this.draftData, required this.index });
  final EventDraftData draftData;
  final int index;

  @override
  State<GeneralDraftCardView> createState() => _GeneralDraftCardViewState();
}

class _GeneralDraftCardViewState extends State<GeneralDraftCardView> {
  @override
  Widget build(BuildContext context) {
    String convertTime(String utcDate) {
      DateTime utcDateTime = DateTime.parse(utcDate);

      DateTime localDateTime = utcDateTime.toLocal();

      String formattedTime = DateFormat("dd/MM/yyyy hh:mm a").format(localDateTime);

      return formattedTime;
    }

    GeneralController generalController = Get.find();
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);



    return GetBuilder<GeneralController>(builder: (controller) {
      return InkWell(
        focusColor: AppColors.transparent,
        overlayColor: WidgetStateProperty.all(AppColors.transparent),
        radius: 0,
        onTap: () {},
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


                      },
                      child: Row(
                        children: [
                          ClipOval(
                            child: AppNetworkImageLoader(
                              url:   widget.draftData.profilePicture??"",
                              height: 40,
                              width: 40,
                              boxFit: BoxFit.cover,
                            ),
                          ),

                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16 / 2),
                            child: Text(
                                widget.draftData.name??(StorageService.getName()??''),
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
                            (widget.draftData.eventTime?.isNotEmpty ?? false)
                                ? convertTime(widget.draftData.eventTime ?? "")
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

                        if (widget.draftData.attachmentFileType == 'Video') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EventPreviewDailoge(
                                  videoPath: widget.draftData.attachment ?? '');
                            },
                          );
                        } else if (widget.draftData.attachmentFileType == 'Image') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EventImagePreviewDialog(
                                imageURL: widget.draftData.attachment ?? '',
                              );
                            },
                          );
                        } else {}
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                                 widget.draftData.thumbnail??"",
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
                          widget.draftData.attachmentFileType == 'Video'?     Container(

                            child: Assets.icons.icPlay.svg( colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                        widget.draftData.title??"",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                widget.draftData.isDirectAdminPost== true ?
                                Text(
                                  "My Draft",

                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                      color: AppColors.grey929da9,
                                      fontWeight: FontWeight.w400),
                                )
                                    : const SizedBox(),
                                const Gap(4),

                              ],
                            ),
                            const Gap(10),
                            (widget.draftData.description?.isNotEmpty?? false) ? Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.draftData.description??"",
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
                            ) : const SizedBox(),
                            (widget.draftData.description?.isNotEmpty?? false) ?      const Gap(10): const SizedBox(),
                            Row(
                              children: [
                                widget.draftData.address != null &&
                                    widget.draftData.address!.isNotEmpty
                                    ? Assets.icons.icLocation.svg()
                                    : const SizedBox(),
                                Expanded(
                                  child: Text(
                                    widget.draftData.address??"",
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
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120.w,
                                      height: 35.h,
                                      child: CommonButton(
                                        color: AppColors.borderColor,
                                        radius: 5,
                                        widget: Text(
                                          'Delete',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                              color: AppColors.grey929da9,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        onPressed: () async {

                                          commonDialog(
                                            context: context,
                                            subtitle: 'Are you sure want to delete draft?',
                                            title: 'Delete Draft',

                                            onTap: () async {


                                              NavigatorRoute.navigateBack(context: context);
                                              await generalController.deleteDraft(
                                                  pl: pl,
                                                  draftId: widget.draftData.id ?? '',
                                                  context: context);

                                            },
                                          );



                                        },
                                      ),
                                    ),
                                    const Gap(20),
                                    SizedBox(
                                      width: 120.w,
                                      height: 35.h,
                                      child: CommonButton(
                                          color: AppColors.white,
                                          radius: 5,
                                          widget: Text(
                                            'Update',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          onPressed: () async {
                                            controller.selectedGeneralDraftData = widget.draftData;

                                            controller.clearGeneralData();


                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,

                                              builder: (context) {
                                                return AddNewGeneral(
                                                  isUser: false,
draftId: widget.draftData.id??"",
                                                );
                                              },
                                            );




                                          }),
                                    )
                                  ],
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
