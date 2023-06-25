import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({Key? key}) : super(key: key);

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  final Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();
  final currentLocation = const LatLng(37.33500926, -122.03272188);
  final destinationLocation = const LatLng(37.33429383, -122.06600055);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: currentLocation),
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
