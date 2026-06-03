import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/map_utils.dart';

part 'search_location_cubit.freezed.dart';
part 'search_location_state.dart';

class SearchLocationCubit extends Cubit<SearchLocationState> {
  SearchLocationCubit() : super(const SearchLocationState());

  // Default camera view
  defaultCameraView() {
    emit(state.copyWith(
        camera: CameraOptions(
            center: Point(
                coordinates: Position(MapUtils.position?.longitude ?? 0,
                    MapUtils.position?.latitude ?? 0)),
            zoom: 13,
            bearing: 0,
            pitch: 0)));
  }

  // map created function
  onMapCreated(MapboxMap mapboxMap, BuildContext context) async {
    emit(state.copyWith(mapboxMap: mapboxMap));
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
    // Set zoom limits
    await mapboxMap.setBounds(CameraBoundsOptions(
      minZoom: 10.00, // Minimum zoom level
      maxZoom: 20.00, // Maximum zoom level
    ));

    // Create point annotation manager
    final pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();
    emit(state.copyWith(pointAnnotationManager: pointAnnotationManager));

    // Add marker at current location
    // if (MapUtils.position != null) {
    //   await addMarker(
    //     Position(
    //       MapUtils.position!.longitude,
    //       MapUtils.position!.latitude,
    //     ),
    //     context,
    //   );
    // }
  }

  // Change map view to place
  navigateToPlaceView(
      {required num lat,
      required num long,
      double? zoom,
      double? bearing,
      double? pitch}) {
    state.mapboxMap!.easeTo(
      CameraOptions(
        center: Point(
          coordinates: Position(long, lat),
        ),
        zoom: zoom ?? 13,
        bearing: bearing,
        pitch: pitch,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  // Add marker on tap
  Future<void> addMarker(Position position, BuildContext context) async {
    if (state.pointAnnotationManager == null) return;

    // Remove existing marker if any
    if (state.selectedMarker != null) {
      await state.pointAnnotationManager?.delete(state.selectedMarker!);
    }

    // Load marker image
    final ByteData bytes = await rootBundle.load('assets/images/marker.jpg');
    final Uint8List markerImage = bytes.buffer.asUint8List();

    // Create new marker
    final marker = PointAnnotationOptions(
      geometry: Point(coordinates: position),
      image: markerImage,
      iconSize: 1.0,
      iconOffset: [0.0, -5.0],
      symbolSortKey: 10,
    );

    final newMarker = await state.pointAnnotationManager?.create(marker);
    emit(state.copyWith(selectedMarker: newMarker));
  }

  // Update marker position on camera change
  void onCameraChange(
      CameraChangedEventData cameraEvent, BuildContext context) {
    addMarker(
      cameraEvent.cameraState.center.coordinates,
      context,
    );
  }
}
