import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../../core/utils/map_utils.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';

part 'notification_settings_cubit.freezed.dart';
part 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  NotificationSettingsCubit() : super(const NotificationSettingsState());

  void init() {
    FirebaseEvents.setFirebaseEvent('alert_setting_screen', {});
    double range = PrefService.getInt(PrefService.userRadius).toDouble();
    emit(state.copyWith(selectedRange: range));
  }

  // Default camera view
  void defaultCameraView() {
    emit(state.copyWith(
      camera: CameraOptions(
        center: Point(
          coordinates: Position(
            MapUtils.position?.longitude ?? 0,
            MapUtils.position?.latitude ?? 0,
          ),
        ),
        zoom: 17 -
            ((PrefService.getInt(PrefService.userRadius).toDouble() - 1) *
                5 /
                9),
        bearing: 0,
        pitch: 0,
      ),
    ));
  }

  void updateZoomLevel(double sliderValue) {
    // Reverse the mapping: slider value 1 -> zoom level 17, slider value 10 -> zoom level 12
    // double zoomLevel = 15 - ((sliderValue - 1) * 5 / 9); // Inverted formula

    /// THIS FORMULA IS COPIED FORM CHAT-GPT
    double zoomLevel = log(40075017 *
            cos((MapUtils.position?.latitude ?? 0) * pi / 180) /
            (512 * (sliderValue * 3))) /
        log(2);

    state.mapboxMap?.easeTo(
      CameraOptions(
        zoom: zoomLevel,
      ),
      MapAnimationOptions(duration: 1000), // Smooth animation for 1 second
    );
  }

  void updateRange(double value) {
    emit(state.copyWith(selectedRange: value.toDouble()));
  }

  // map created function
  onMapCreated(MapboxMap mapboxMap, BuildContext context) async {
    emit(state.copyWith(mapboxMap: mapboxMap));

    double zoomLevel = log(40075017 *
            cos((MapUtils.position?.latitude ?? 0) * pi / 180) /
            (512 * (state.selectedRange * 3))) /
        log(2);

    state.mapboxMap?.easeTo(
      CameraOptions(
        zoom: zoomLevel,
      ),
      MapAnimationOptions(duration: 1000), // Smooth animation for 1 second
    );

    // Hide compass
    mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    // Hide scale bar
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(
      enabled: false,
    ));
    // Hide logo
    mapboxMap.logo.updateSettings(LogoSettings(
      enabled: false,
    ));
    // Hide info button
    mapboxMap.attribution.updateSettings(AttributionSettings(
      enabled: false,
    ));
    mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: false,
      pulsingEnabled: false,
      puckBearingEnabled: false,
    ));
    // Update gesture settings
    mapboxMap.gestures.updateSettings(GesturesSettings(
      quickZoomEnabled: false,
      simultaneousRotateAndPinchToZoomEnabled: false,
    ));
  }

  Future<bool> updateRadius() async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.updateUserRadius(data: {
        "radius": state.selectedRange.toInt(),
        "notificationPreferences": {
          "dangerousTools": state.dangerousNotification,
          "trafficMishaps": state.trafficNotification,
          "firearmIncidents": state.firearmIncidentNotification,
          "physicalAltercations": state.physicalAltercationNotification,
          "minorFires": state.minorFiresNotification,
          "majorBlazes": state.majorBlazesNotification,
          "lostPersons": state.lostPetsNotification,
          "lostPets": state.lostPetsNotification,
          "communityHealth": state.communityHealthNotification,
          "severeWeatherDisasters": state.serverWeatherNotification,
          "localOffenderWatch": state.localOffenderNotification,
          "transportUpdates": state.transportNotification,
          "promotionalAlerts": state.promotionalNotification,
          "police": state.policeNotification,
          "rally": state.rallyNotification,
          "massRunning": state.massRunningNotification,
          "goons": state.goonsNotification,
          "unknownEvent": state.unknownEventNotification,
          "others": state.otherNotification
        }
      });
      if (response.status == true) {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast('Notification settings updated');
        PrefService.setValue(
            PrefService.userRadius, state.selectedRange.toInt());
        return true;
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast('Radius Update Error');
        return false;
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      return false;
    }
  }

  updateDangerous(bool value) {
    emit(state.copyWith(dangerousNotification: value));
  }

  updateTraffic(bool value) {
    emit(state.copyWith(trafficNotification: value));
  }

  updateFirearmIncidentNotification(bool value) {
    emit(state.copyWith(firearmIncidentNotification: value));
  }

  updatePhysicalAltercationNotification(bool value) {
    emit(state.copyWith(physicalAltercationNotification: value));
  }

  updateMinorFiresNotification(bool value) {
    emit(state.copyWith(minorFiresNotification: value));
  }

  updateMajorBlazesNotification(bool value) {
    emit(state.copyWith(majorBlazesNotification: value));
  }

  updateLostPersonsNotification(bool value) {
    emit(state.copyWith(lostPersonsNotification: value));
  }

  updateLostPetsNotification(bool value) {
    emit(state.copyWith(lostPetsNotification: value));
  }

  updateCommunityHealthNotification(bool value) {
    emit(state.copyWith(communityHealthNotification: value));
  }

  updateServerWeatherNotification(bool value) {
    emit(state.copyWith(serverWeatherNotification: value));
  }

  updateLocalOffenderNotification(bool value) {
    emit(state.copyWith(localOffenderNotification: value));
  }

  updateTransportNotification(bool value) {
    emit(state.copyWith(transportNotification: value));
  }

  updatePromotionalNotification(bool value) {
    emit(state.copyWith(promotionalNotification: value));
  }

  updatePoliceNotification(bool value) {
    emit(state.copyWith(policeNotification: value));
  }

  updateRallyNotification(bool value) {
    emit(state.copyWith(rallyNotification: value));
  }

  updateMassRunningNotification(bool value) {
    emit(state.copyWith(massRunningNotification: value));
  }

  updateGoonsNotification(bool value) {
    emit(state.copyWith(goonsNotification: value));
  }

  updateUnknownEventNotification(bool value) {
    emit(state.copyWith(unknownEventNotification: value));
  }

  updateOtherNotification(bool value) {
    emit(state.copyWith(otherNotification: value));
  }
}
