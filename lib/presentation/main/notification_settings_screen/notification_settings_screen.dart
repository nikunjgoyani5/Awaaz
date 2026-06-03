import 'dart:ui';

import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/widget/app_common_loader_screen.dart';
import 'package:eagle_eye/core/widget/app_network_image_loader.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/core/widget/common_button.dart';
import 'package:eagle_eye/presentation/main/notification_settings_screen/bloc/notification_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/app_prefrence.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String customStyleURL =
        "mapbox://styles/rohitlogicgo/cm488770q018r01sd4ci45y4n";
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Alert Settings',
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return AppCommonLoaderScreen(
            inAsyncCall: state.isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*      Text(
                    "Choose the kinds of notifications you'd like to get and set the range from your current location.",
                    style: TextStyles.medium(22.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                  spaceH(20.h),
                  Text(
                    "Notification Distance",
                    style: TextStyles.bold(28.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                  spaceH(20.h),
                  Text(
                    "Set the radius for events you want to receive notifications about.",
                    style: TextStyles.medium(20.sp,
                        fontColor: AppColors.whiteColor),
                  ),*/
                  spaceH(5.h),
                  SizedBox(
                    height: 230.h,
                    child: BlocBuilder<NotificationSettingsCubit,
                        NotificationSettingsState>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            MapWidget(
                              styleUri: customStyleURL,
                              key: const ValueKey("mapWidget"),
                              cameraOptions: state.camera,
                              onMapCreated: (mapBox) {
                                context
                                    .read<NotificationSettingsCubit>()
                                    .onMapCreated(mapBox, context);
                              },
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 130,
                                width: 130,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                    child: Container(
                                      color: Colors.grey.withValues(alpha: 0.2),
                                      padding: EdgeInsets.all(45.sp),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        padding: EdgeInsets.all(4),
                                        child: AppNetworkImageLoader(
                                          url: PrefService.getString(
                                              PrefService.profileUrl),
                                          borderRadius: 100,
                                          boxFit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.all(30.sp),
                                  //   child: Image.asset(
                                  //     'assets/images/notification_alert_vector.png',
                                  //     height: 150.h,
                                  //     width: 150.w,
                                  //   ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  spaceH(20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          buildWhen: (previous, current) =>
                              previous.selectedRange != current.selectedRange,
                          builder: (context, state) {
                            return Text(
                              "Radius: ${state.selectedRange == 0.0 ? 5.0 : state.selectedRange.toInt()} km",
                              style: TextStyles.medium(16.sp,
                                  fontColor: AppColors.whiteColor),
                            );
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          buildWhen: (previous, current) =>
                              previous.selectedRange != current.selectedRange,
                          builder: (context, state) {
                            return Slider(
                              activeColor: AppColors.whiteColor,
                              value: state.selectedRange,
                              // Current slider value
                              min: 1,
                              // Minimum value
                              max: 12,
                              // Maximum value
                              divisions: 9,
                              // Number of divisions for smooth steps
                              label: "${state.selectedRange.toInt()}",
                              // Display the current value
                              onChanged: (value) {
                                context
                                    .read<NotificationSettingsCubit>()
                                    .updateZoomLevel(value);
                                context
                                    .read<NotificationSettingsCubit>()
                                    .updateRange(value);
                              },
                            );
                          },
                        ),
                        spaceH(10.h),
                        Text(
                          'Incident Categories',
                          style: TextStyles.bold(22.sp,
                              fontColor: AppColors.whiteColor),
                        ),
                        spaceH(20.h),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.dangerousIcon,
                                title: 'Dangerous Tools',
                                subTitle:
                                    'Reports involving non-firearm weapons (e.g., Pepper Spray,Knife, Hammer, Bat, Chair',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateDangerous(value);
                                },
                                value: state.dangerousNotification);
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.trafficMishapsIcon,
                                value: state.trafficNotification,
                                title: 'Traffic Mishaps',
                                subTitle:
                                    'Updates on vehicle accidents, including potential road closures or detours.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateTraffic(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.fireArmsIcon,
                                title: 'Firearm Incidents ',
                                subTitle:
                                    'Events involving guns, such as gunfire or armed robberies.',
                                value: state.firearmIncidentNotification,
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateFirearmIncidentNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath:
                                    AppImageAsset.physicalAltercationsIcon,
                                title: 'Physical Altercations ',
                                subTitle:
                                    'Local reports of public fights, assaults, or related disturbances.',
                                value: state.physicalAltercationNotification,
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updatePhysicalAltercationNotification(
                                          value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.minorFiresIcon,
                                title: 'Minor Fires ',
                                subTitle:
                                    'Incidents like trash fires, smoke sightings, or small maintenance-related blazes.',
                                value: state.minorFiresNotification,
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateMinorFiresNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.majorBlazesIcon,
                                title: 'Major Blazes',
                                value: state.majorBlazesNotification,
                                subTitle:
                                    'Significant fire incidents, including large building fires, wildfires, and hazardous blazes requiring emergency response.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateMajorBlazesNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.lostPersonIcon,
                                title: 'Lost Persons',
                                value: state.lostPersonsNotification,
                                subTitle:
                                    'Reports of missing individuals, search efforts, and updates on found persons.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateLostPersonsNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.lostPetsIcon,
                                value: state.lostPetsNotification,
                                title: 'Lost Pets',
                                subTitle:
                                    'Alerts and updates about missing pets, sightings, and reunions with owners.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateLostPetsNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.communityHealthIcon,
                                value: state.communityHealthNotification,
                                title: 'Community Health',
                                subTitle:
                                    'Updates on local health initiatives, disease outbreaks, wellness programs, and public safety advisories.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateCommunityHealthNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.severeWeatherIcon,
                                title: 'Severe Weather & Disasters',
                                value: state.serverWeatherNotification,
                                subTitle:
                                    'Coverage of extreme weather events, natural disasters, and emergency response updates.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateServerWeatherNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.localOffenderIcon,
                                value: state.localOffenderNotification,
                                title: 'Local Offender Watch',
                                subTitle:
                                    'Alerts and reports on criminal activities, wanted individuals, and public safety warnings in the community.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateLocalOffenderNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.transportUpdatesIcon,
                                value: state.transportNotification,
                                title: 'Transport Updates',
                                subTitle:
                                    'Real-time reports on road closures, traffic conditions, public transit changes, and travel advisories.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateTransportNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.promotionalAlertsIcon,
                                value: state.promotionalNotification,
                                title: 'Promotional Alerts',
                                subTitle:
                                    'Notifications about local deals, special offers, events, and business promotions.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updatePromotionalNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.policeIcon,
                                value: state.policeNotification,
                                title: 'Police',
                                subTitle:
                                    'Updates on law enforcement activities, crime reports, public safety initiatives, and official statements.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updatePoliceNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.rallyIcon,
                                value: state.rallyNotification,
                                title: 'Rally',
                                subTitle:
                                    'Announcements and coverage of public gatherings, protests, demonstrations, and community marches.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateRallyNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.massRunningIcon,
                                value: state.massRunningNotification,
                                title: 'Mass Running',
                                subTitle:
                                    'Reports on large-scale public runs, sudden group movements, and events involving mass gatherings on foot.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateMassRunningNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.goonIcon,
                                value: state.goonsNotification,
                                title: 'Goons - NSHAP',
                                subTitle:
                                    'Reports on gang activities, vandalism, organized crime, and related security concerns in the community.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateGoonsNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.unknownIcon,
                                value: state.unknownEventNotification,
                                title: 'Unknown Event',
                                subTitle:
                                    'Reports on mysterious or unidentified incidents that require further verification or investigation.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateUnknownEventNotification(value);
                                });
                          },
                        ),
                        BlocBuilder<NotificationSettingsCubit,
                            NotificationSettingsState>(
                          builder: (context, state) {
                            return optionWidget(
                                imagePath: AppImageAsset.otherIcon,
                                value: state.otherNotification,
                                title: 'Others',
                                subTitle:
                                    'Miscellaneous news and reports that do not fit into specific categories but are still relevant to the community.',
                                onChange: (bool value) {
                                  context
                                      .read<NotificationSettingsCubit>()
                                      .updateOtherNotification(value);
                                });
                          },
                        ),
                        CommonButton(
                            color: AppColors.whiteColor,
                            widget: Text('Save',
                                style: TextStyles.bold(23.sp,
                                    fontColor: AppColors.blackColor)),
                            onPressed: () async {
                              await context
                                  .read<NotificationSettingsCubit>()
                                  .updateRadius()
                                  .then(
                                (value) {
                                  if (value) {
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            }),
                        spaceH(20.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget optionWidget(
      {required String imagePath,
      required String title,
      required String subTitle,
      required bool value,
      required Function(bool value) onChange}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 40.h,
            width: 40.h,
          ),
          Gap(10.w),
          Expanded(
            child: GestureDetector(
              onTap: () {
                onChange.call(!value);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.regular(18.sp,
                        fontColor: AppColors.whiteColor),
                  ),
                  Text(
                    subTitle,
                    style: TextStyles.medium(14.sp,
                        fontColor: AppColors.textHintGrayColor),
                  ),
                ],
              ),
            ),
          ),
          Theme(
            data: ThemeData(useMaterial3: false),
            child: Switch(
              value: value,
              onChanged: (value) {
                onChange.call(value);
              },
              activeColor: value ? AppColors.primaryColor : Color(0xff84B7FB),
              inactiveThumbColor: Colors.white,
              activeTrackColor: Color(0xff84B7FB),
              inactiveTrackColor: Color(0xff2C2C2C),
            ),
          )
        ],
      ),
    );
  }
}
