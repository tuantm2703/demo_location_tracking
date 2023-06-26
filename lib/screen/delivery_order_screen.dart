import 'dart:convert';

import 'package:demo_location_tracking/config/app_config.dart';
import 'package:demo_location_tracking/config/app_route.dart';
import 'package:demo_location_tracking/data/google_map_location_response.dart';
import 'package:demo_location_tracking/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeliveryOrderScreen extends StatefulWidget {
  const DeliveryOrderScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryOrderScreen> createState() => _DeliveryOrderScreenState();
}

class _DeliveryOrderScreenState extends State<DeliveryOrderScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 32,
                padding: const EdgeInsets.only(left: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    Map responseMap = await onGetDestinationController();
                    printDebug('get result: $responseMap');
                    Navigator.pushNamed(context, AppRoutes.locationTracking,arguments: responseMap);
                  },
                  child: const Text(
                    'Bắt đầu giao',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
        isLoading
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFF000000).withOpacity(0.3),
                child: const Center(
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  onGetDestinationController() async {
    Map responseMap = {};
    setState(() {
      isLoading = true;
    });
    String address = 'Hollywood Boulevard, Vine St, Los Angeles, CA 90028, USA';
    var url =
        Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${AppConfig.googleApiKey}');
    var response = await http.get(url);
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      GoogleMapLocationResponse modelResponse = GoogleMapLocationResponse.fromJson(jsonDecode(response.body));
      double? destinationLat = (modelResponse.results ?? []).first.geometry?.location?.lat;
      double? destinationLng = (modelResponse.results ?? []).first.geometry?.location?.lng;
      responseMap = {'lat':destinationLat,'lng':destinationLng};
    }
    return responseMap;
  }
}
