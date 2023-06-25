import 'dart:async';

import 'package:demo_location_tracking/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({Key? key}) : super(key: key);

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  final Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();
  final currentLocation = const LatLng(37.33500926, -122.03272188);
  final destinationLocation = const LatLng(37.33429383, -122.06600055);
  List<LatLng> pointsCoordinate = [];

  @override
  void initState() {
    getPolylinePoints();
    super.initState();
  }

  Future getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.googleApiKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    if (polylineResult.points.isNotEmpty) {
      pointsCoordinate.clear();
      pointsCoordinate = [...polylineResult.points.map((e) => LatLng(e.latitude, e.longitude))];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: currentLocation),
        polylines: {
          Polyline(polylineId: const PolylineId("route"), points: pointsCoordinate, color: Colors.blue, width: 4)
        },
        markers: {
          Marker(
            markerId: const MarkerId('Source current Location'),
            position: currentLocation,
          ),
          Marker(
            markerId: const MarkerId('Destination Location'),
            position: destinationLocation,
          )
        },
      ),
    );
  }
}
