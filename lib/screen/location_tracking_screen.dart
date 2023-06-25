import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({Key? key}) : super(key: key);

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  final currentLocation = const LatLng(34.0928, -118.3287);
  final Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 14.5,
        ),
      ),
    );
  }
}
