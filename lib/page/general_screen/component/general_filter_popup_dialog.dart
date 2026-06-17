import 'package:eagle_eye_admin/controller/general_controller.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneralFilterPopupDialog extends StatefulWidget {
  const GeneralFilterPopupDialog({super.key});

  @override
  State<GeneralFilterPopupDialog> createState() =>
      _GeneralFilterPopupDialogState();
}

class _GeneralFilterPopupDialogState extends State<GeneralFilterPopupDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 290,
          right: 280,
          child: AlertDialog(
            backgroundColor: AppColors.transparent,
            content: GetBuilder<GeneralController>(builder: (controller) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                width: 180,
                height: 205,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.grey2C2C2C),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.generalCategory.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.onSelectCategory(
                                controller.generalCategory[index].id ?? '');

                            setState(() {});
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: AppColors.black,
                                  value: controller.selectedFilterCategoryList
                                      .contains(
                                          controller.generalCategory[index].id),
                                  fillColor:
                                      WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return AppColors.blue;
                                    }
                                    return Colors.transparent;
                                  }),
                                  onChanged: (value) async {
                                    controller.onSelectCategory(
                                        controller.generalCategory[index].id ??
                                            '');

                                    setState(() {});
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                controller.generalCategory[index].eventName ??
                                    '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller.isDropDownOpen = false;
                        controller.filterGeneralList.clear();
                        controller.pageNumber = 1;
                        await controller.getGeneralPostList(context: context);
                        controller.update();
                        setState(() {});
                      },
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(
                            4,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Apply',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
