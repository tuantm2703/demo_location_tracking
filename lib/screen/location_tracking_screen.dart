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
  LocationData? currentLocation;

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (sourceLocation == null && destinationLocation == null && currentLocation == null)
          ? const Center(child: Text('Loading'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
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
    //sourceLocation = const LatLng(37.33500926, -122.03272188);
    if (currentLocation != null) {
      sourceLocation = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    }
    destinationLocation = const LatLng(34.101663, -118.326710);
    printDebug('Source: - Lat:${sourceLocation?.latitude} - Long:${sourceLocation?.longitude}');
    printDebug('Destination: - Lat:${destinationLocation?.latitude} - Long:${destinationLocation?.longitude}');
    setState(() {});
  }

  getPolyPoints() async {
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

  initData() async {
    await getCurrentLocation();
    initLocation();
    await getPolyPoints();
    onListenChangeLocation();
  }

  getCurrentLocation() async {
    currentLocation = await Location().getLocation();
    printDebug('First current location: - Lat:${currentLocation?.latitude} - Long:${currentLocation?.longitude}');
  }

  onListenChangeLocation() async {
    Location location = Location();
    GoogleMapController googleMapController = await mapCompleter.future;
    location.onLocationChanged.listen(
      (event) {
        currentLocation = event;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 16,
              target: LatLng(
                event.latitude!,
                event.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }
}
