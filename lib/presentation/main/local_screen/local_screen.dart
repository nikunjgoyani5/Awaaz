import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/utils/map_utils.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  MapboxMap? mapboxMap;
  final String customStyleURL =
      // "mapbox://styles/rohitlogicgo/cm4707c3r010n01siap3wgvxo";
      "mapbox://styles/rohitlogicgo/cm3y3qact00d601si02hx7bqb";

  Timer? radarTimer;
  double radarRadius = 10.0; // Starting radius
  final double maxRadarRadius = 100.0; // Maximum radius
  final String radarSourceId = 'radar-source';
  final String radarLayerId = 'radar-layer';
  CameraOptions? camera;
  PointAnnotationManager? pointAnnotationManager;
  PointAnnotation? pointAnnotation;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    // Set compass settings
    mapboxMap.compass
        .updateSettings(CompassSettings(marginTop: 50, rotation: 20));
    // Hide scale bar
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    // Hide logo
    mapboxMap.logo.updateSettings(LogoSettings(
      enabled: false,
    ));
    // Hide info button
    mapboxMap.attribution.updateSettings(AttributionSettings(
      enabled: false,
    ));
    mapboxMap.location.updateSettings(LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        puckBearingEnabled: true,
        pulsingMaxRadius: 50));
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
    mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      pointAnnotationManager = value;
      final ByteData bytes = await rootBundle.load('assets/images/fire.png');
      final Uint8List list = bytes.buffer.asUint8List();
      createOneAnnotation(list);
    });
    mapboxMap.annotations.createCircleAnnotationManager().then((value) {
      circleAnnotationManager = value;
      // createCircleAnnotation();
    });
  }

  bool is3DEnabled = false;
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;

  void createOneAnnotation(Uint8List list) async {
    final circularImage = await addCircularBorder(list);

    pointAnnotationManager
        ?.create(PointAnnotationOptions(
            geometry: Point(
                coordinates: Position(
              72.808625,
              21.224266,
            )),
            iconSize: 1.2,
            iconOffset: [0.0, -5.0],
            symbolSortKey: 10,
            image: circularImage))
        .then((value) => pointAnnotation = value);
  }

  Future<Uint8List> addCircularBorder(Uint8List originalImage) async {
    final codec = await ui.instantiateImageCodec(originalImage);
    final frame = await codec.getNextFrame();
    final ui.Image originalUiImage = frame.image;

    final double borderWidth = 3;
    final double padding = 10;
    final double triangleHeight = 10;
    final size = originalUiImage.width.toDouble() + (borderWidth + padding) * 2;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(pictureRecorder);

    final paint = ui.Paint()..isAntiAlias = true;

    final center = size / 2;
    paint.color = const ui.Color(0xFFFF6929);
    paint.style = ui.PaintingStyle.stroke;
    paint.strokeWidth = borderWidth;
    canvas.drawCircle(
      ui.Offset(center, center),
      center - borderWidth / 2,
      paint,
    );

    final innerDiameter = size - (borderWidth + padding) * 2;
    canvas.drawImageRect(
      originalUiImage,
      ui.Rect.fromLTWH(0, 0, originalUiImage.width.toDouble(),
          originalUiImage.height.toDouble()),
      ui.Rect.fromLTWH(
        borderWidth + padding,
        borderWidth + padding,
        innerDiameter,
        innerDiameter,
      ),
      ui.Paint(),
    );

    paint.style = ui.PaintingStyle.fill;
    final trianglePath = ui.Path();
    trianglePath.moveTo(center - triangleHeight, size + 5);
    trianglePath.lineTo(center + triangleHeight, size + 5);
    trianglePath.lineTo(center, size + triangleHeight + 5);
    trianglePath.close();

    canvas.drawPath(
      trianglePath,
      paint..color = const ui.Color(0xFFf1f1f1),
    );

    final picture = pictureRecorder.endRecording();
    final ui.Image finalImage = await picture.toImage(
      size.toInt(),
      (size + triangleHeight + 5).toInt(),
    );
    final byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  createCircleAnnotation() {
    circleAnnotationManager
        ?.create(CircleAnnotationOptions(
          geometry: Point(
              coordinates: Position(
            72.808625,
            21.224266,
          )),
          // circleColor: Colors.yellow.value,
          circleRadius: 12.0,
        ))
        .then((value) => circleAnnotation = value);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Transparent status bar
      statusBarIconBrightness: Brightness.dark,
      // Status bar icons color
      statusBarBrightness: Brightness.dark,
      // Status bar brightness
      systemNavigationBarColor: Colors.white,
      // Navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.dark, // Navigation bar icons color
    ));
    initMap();
    _onMapCreated;
  }

  Future initMap() async {
    camera = CameraOptions(
        center: Point(
            coordinates: Position(MapUtils.position?.longitude ?? 0,
                MapUtils.position?.latitude ?? 0)),
        zoom: 15,
        bearing: 0,
        pitch: 0);
  }

  void _onCameraChange(CameraChangedEventData cameraEvent) {
    final double zoom = cameraEvent.cameraState.zoom;

    if (zoom > 15 && !is3DEnabled) {
      // Enable 3D View
      setState(() {
        is3DEnabled = true;
      });
      mapboxMap?.setCamera(
        CameraOptions(
          bearing: 0,
          pitch: 60, // Set pitch for 3D view
        ),
      );
    } else if (zoom <= 15 && is3DEnabled) {
      // Reset to 2D View
      setState(() {
        is3DEnabled = false;
      });
      mapboxMap?.setCamera(
        CameraOptions(
          bearing: 0,
          pitch: 0, // Reset pitch for 2D view
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        styleUri: customStyleURL,
        key: const ValueKey("mapWidget"),
        onCameraChangeListener: _onCameraChange,
        cameraOptions: camera,
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
