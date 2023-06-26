import 'package:demo_location_tracking/config/app_route.dart';
import 'package:demo_location_tracking/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

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
    List<geocoding.Location> locations = await geocoding.locationFromAddress(address);
    if(locations.isNotEmpty){
      geocoding.Location geoCodingLocation = locations.first;
      responseMap = {'lat':geoCodingLocation.latitude,'lng':geoCodingLocation.longitude};
    }
    setState(() {
      isLoading = false;
    });
    return responseMap;
  }
}
