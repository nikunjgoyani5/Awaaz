import 'package:eagle_eye_admin/controller/attach_file_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/model/get_filter_events.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_image_preview_dialog.dart';
import 'package:eagle_eye_admin/page/event_screen/component/event_preview_dailoge.dart';
import 'package:eagle_eye_admin/page/user_profile_screen/user_profile_view.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AttachEventCardView extends StatefulWidget {
  final FilterEvents eventData;

  const AttachEventCardView({super.key, required this.eventData});

  @override
  State<AttachEventCardView> createState() => _AttachEventCardViewState();
}

class _AttachEventCardViewState extends State<AttachEventCardView> {
  AttachFileController controller = Get.put(AttachFileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttachFileController>(builder: (controller) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h) +
            EdgeInsets.only(right: 15.w),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.borderColor,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  radius: 0,
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UserProfileView(
                          userId: widget.eventData.userId ?? "",
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      ClipOval(
                        child: AppNetworkImageLoader(
                          url: widget.eventData.profilePicture ?? "",
                          height: 40,
                          width: 40,
                          boxFit: BoxFit.contain,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16 / 2),
                        child: Text(
                          widget.eventData.name ??
                              (StorageService.getName() ?? ''),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500),
                        ),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     gradient: const LinearGradient(
                      //       begin: Alignment.centerLeft,
                      //       end: Alignment.centerRight,
                      //       colors: [
                      //         Color(0xff1FA9FF),
                      //         Color(0xff1C7EFF),
                      //       ],
                      //     ),
                      //     borderRadius: BorderRadius.circular(50),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 8, vertical: 1),
                      //     child: Text(
                      //       "15%",
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .bodySmall!
                      //           .copyWith(
                      //               color: AppColors.white,
                      //               fontWeight: FontWeight.w500),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Assets.icons.icWatch.svg(
                      height: 20.h,
                      width: 20.w,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16 / 2),
                      child: Text(
                        widget.eventData.eventTime != null &&
                                widget.eventData.eventTime!.isNotEmpty
                            ? controller
                                .convertTime(widget.eventData.eventTime!)
                            : '',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColors.grey909090,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (widget.eventData.attachmentFileType == 'Video') {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return EventPreviewDailoge(
                              videoPath: widget.eventData.attachment ?? '');
                        },
                      );
                    } else if (widget.eventData.attachmentFileType == 'Image') {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return EventImagePreviewDialog(
                            imageURL: widget.eventData.attachment ?? '',
                          );
                        },
                      );
                    } else {}
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppNetworkImageLoader(
                          url: widget.eventData.thumbnail ?? "",
                          height: 40,
                          width: 40,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                      widget.eventData.attachmentFileType == 'Video'
                          ? Assets.icons.icPlay.svg()
                          : const SizedBox(),
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
                      widget.eventData.title ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w500),
                    ),
                    const Gap(10),
                    Text(
                      widget.eventData.description ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w100),
                    ),
                    const Gap(10),
                    (widget.eventData.address?.isNotEmpty ?? false)
                        ? Row(
                            children: [
                              Assets.icons.icLocation.svg(
                                height: 20.h,
                                width: 20.w,
                              ),
                              Expanded(
                                child: Text(
                                  widget.eventData.address ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: AppColors.grey909090,
                                          fontWeight: FontWeight.w400),
                                ),
                              ),
                              Gap(10.w),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ))
              ],
            )
          ],
        ),
      );
    });
  }
}
