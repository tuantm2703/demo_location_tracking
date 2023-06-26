import 'dart:async';

import 'package:demo_location_tracking/config/app_config.dart';
import 'package:demo_location_tracking/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({Key? key}) : super(key: key);

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  final Completer<GoogleMapController> mapCompleter = Completer();
  LatLng? sourceLocation, destinationLocation;
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    initLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (sourceLocation == null && destinationLocation == null)
          ? const Text('Loading')
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: sourceLocation!,
                zoom: 13.5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('source'),
                  position: sourceLocation!,
                ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position: destinationLocation!,
                ),
              },
              onMapCreated: (mapController) {
                mapCompleter.complete(mapController);
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: polylineCoordinates,
                  color: Colors.blue,
                  width: 4,
                ),
              },
            ),
    );
  }

  void initLocation() {
    sourceLocation = const LatLng(37.33500926, -122.03272188);
    destinationLocation = const LatLng(37.33429383, -122.06600055);
    printDebug('Source: - Lat:${sourceLocation?.latitude} - Long:${sourceLocation?.longitude}');
    printDebug('Destination: - Lat:${destinationLocation?.latitude} - Long:${destinationLocation?.longitude}');
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    if (sourceLocation != null && destinationLocation != null) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        AppConfig.googleApiKey,
        PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
        PointLatLng(destinationLocation!.latitude, destinationLocation!.longitude),
      );
      polylineCoordinates.clear();
      if (result.points.isNotEmpty) {
        polylineCoordinates = [...result.points.map((e) => LatLng(e.latitude, e.longitude)).toList()];
        setState(() {});
      }
    }
  }
}
