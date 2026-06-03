import 'package:eagle_eye/core/theme/colors.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/widget/common_app_bar.dart';
import 'package:eagle_eye/presentation/main/general_go_live/bloc/general_post_cubit.dart';
import 'package:eagle_eye/presentation/main/search_location_screen/bloc/search_location_cubit.dart';
import 'package:eagle_eye/presentation/main/send_alert/bloc/send_alert_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

import '../../../core/utils/map_utils.dart';
import '../../../routes/app_navigation.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final String customStyleURL =
      "mapbox://styles/rohitlogicgo/cm488770q018r01sd4ci45y4n";

  final TextEditingController locationController = TextEditingController();
  String? selectedAddress;
  mapbox.MapboxMap? _mapboxMap;
  mapbox.PointAnnotationManager? _pointAnnotationManager;
  mapbox.PointAnnotation? _currentMarker;

  @override
  void initState() {
    super.initState();
    context.read<SearchLocationCubit>().defaultCameraView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
        title: 'Search location',
        action: [
          if (selectedAddress != null)
            IconButton(
              onPressed: () {
                context.read<SendAlertCubit>().setAddressFromMap(
                    selectedAddress ?? '',
                    lat: latitude,
                    long: longitude);
                context.read<GeneralPostCubit>().selectLocationGen(
                    add: selectedAddress ?? '',
                    lati: latitude,
                    logi: longitude);
                NavigatorRoute.navigateBack(context);
              },
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
            )
        ],
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            child: BlocBuilder<SearchLocationCubit, SearchLocationState>(
              builder: (context, state) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: mapbox.MapWidget(
                    styleUri: customStyleURL,
                    key: const ValueKey("mapWidget"),
                    cameraOptions: state.camera,
                    onMapCreated: (mapBox) async {
                      _mapboxMap = mapBox;
                      context
                          .read<SearchLocationCubit>()
                          .onMapCreated(mapBox, context);

                      // Create Annotation Manager for markers
                      final annotationManager = await mapBox.annotations
                          .createPointAnnotationManager();
                      _pointAnnotationManager = annotationManager;
                    },
                    onTapListener: (mapData) async {
                      latitude = mapData.point.coordinates.lat.toDouble();
                      longitude = mapData.point.coordinates.lng.toDouble();
                      _handleMapTap(
                        mapData.point.coordinates.lat.toDouble(),
                        mapData.point.coordinates.lng.toDouble(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                context.read<SendAlertCubit>().setAddressFromMap(
                    selectedAddress ?? '',
                    lat: latitude,
                    long: longitude);
                context.read<GeneralPostCubit>().selectLocationGen(
                    add: selectedAddress ?? '',
                    lati: latitude,
                    logi: longitude);
                NavigatorRoute.navigateBack(context);
              },
              child: Container(
                  // height: 55.h,
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    locationController.text.trim().isEmpty
                        ? 'Tap on the map to select a location'
                        : locationController.text,
                    style: TextStyles.semiBold(20.sp,
                        fontColor: AppColors.blackColor),
                  )),
            ),
          ),
          BlocBuilder<SearchLocationCubit, SearchLocationState>(
            buildWhen: (previous, current) =>
                previous.mapboxMap != current.mapboxMap,
            builder: (context, state) {
              return Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  onPressed: () {
                    if (state.mapboxMap != null) {
                      context.read<SearchLocationCubit>().navigateToPlaceView(
                            lat: MapUtils.position?.latitude ?? 0,
                            long: MapUtils.position?.longitude ?? 0,
                            zoom: 13,
                            bearing: 0,
                            pitch: 0,
                          );
                    }
                  },
                  icon: const Icon(Icons.my_location,
                      color: Colors.white, size: 35),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  double latitude = 0.0;
  double longitude = 0.0;

  /// Handles map tap to add marker and update address
  Future<void> _handleMapTap(double lat, double lon) async {
    // Update camera to new tapped location43..
    _mapboxMap?.flyTo(
      mapbox.CameraOptions(
        center: mapbox.Point(coordinates: mapbox.Position(lon, lat)),
        zoom: 15.0,
        bearing: 0,
        pitch: 0,
      ),
      mapbox.MapAnimationOptions(duration: 1000),
    );

    // Reverse geocode to get address
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            "${place.street}, ${place.subLocality} ${place.locality}, ${place.country} ${place.postalCode}";

        setState(() {
          selectedAddress = address;
          locationController.text = address;
        });
        // context
        //     .read<SendAlertCubit>()
        //     .setAddressFromMap(address, lat: lat, long: lon);
        // context.read<GeneralPostCubit>().selectLocationGen(
        //     add: selectedAddress ?? '', lati: lat, logi: lon);
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }

    // Add a marker at the tapped location
    await _addMarker(lat, lon);
  }

  /// Adds a marker on the map and ensures only one marker exists
  Future<void> _addMarker(double lat, double lon) async {
    // Remove the existing marker before adding a new one
    if (_currentMarker != null) {
      _pointAnnotationManager?.delete(_currentMarker!);
    }
    final ByteData bytes = await rootBundle.load('assets/images/pin.png');
    final Uint8List markerImage = bytes.buffer.asUint8List();

    _currentMarker = await _pointAnnotationManager?.create(
      mapbox.PointAnnotationOptions(
        geometry: mapbox.Point(coordinates: mapbox.Position(lon, lat)),
        image: markerImage, // Custom marker image
        iconSize: 0.8, // Adjust marker size
      ),
    );
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }
}
