import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/text_styles.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SelectDistanceDialog extends StatefulWidget {
  const SelectDistanceDialog({super.key, required this.onTapDone});
  final VoidCallback onTapDone;
  @override
  State<SelectDistanceDialog> createState() => _SelectDistanceDialogState();
}

class _SelectDistanceDialogState extends State<SelectDistanceDialog> {
  EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: StatefulBuilder(
        builder: (con, update) {
          return GetBuilder<DashboardController>(
            builder: (controller) {
              return Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 30,
                            width: 70,
                          ),
                          Text(
                            "Select Distance",
                            style: TextStyles.bold(25, fontColor: Colors.black),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '${controller.radiusValue.toStringAsFixed(2)} KM',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                      const Gap(30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Text(
                          'You can select a range for location to show events!',
                          textAlign: TextAlign.center,
                          style:
                              TextStyles.semiBold(18, fontColor: Colors.black),
                        ),
                      ),
                      const Gap(40),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                                color: Colors.black45, shape: BoxShape.circle),
                            child: Text(
                              '1',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              min: 1,
                              max: 500,
                              value: controller.radiusValue,
                              activeColor: AppColors.black,
                              inactiveColor: AppColors.borderColor,
                              onChanged: (value) {
                                controller.radiusValue = value;
                                setState(() {});
                                controller.update();
                                update.call(() {});
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '500',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      CommonTextField(
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          num value =
                              num.parse(controller.distanceController.text);
                          if (value > 500) {
                            controller.radiusValue = 500;
                            controller.distanceController.text = '500';
                          } else if (double.tryParse(
                                  controller.distanceController.text) ==
                              0) {
                            controller.distanceController.text = '1';
                            controller.radiusValue = 1.00;
                          } else {
                            controller.radiusValue =
                                double.parse(value.toStringAsFixed(2));
                          }

                          setState(() {});
                          update.call(() {});
                          controller.update();
                        },
                        textStyle: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: AppColors.black),
                        hintText: 'Enter Distance',
                        controller: controller.distanceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$')),
                        ],
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 35,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  overlayColor:
                                      AppColors.black.withValues(alpha: 0.2),
                                  shadowColor: Colors.black,
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: widget.onTapDone,
                                child: Text(
                                  'Done',
                                  style: TextStyles.semiBold(17,
                                      fontColor: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ));
            },
          );
        },
      ),
    );
  }
}
