import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

printDebug(String message){
  if (kDebugMode) {
    print('=====> $message');
  }
}

double maxWaitingDistance = 1000;
onCalculatorDistanceToInventory(List<LatLng> inventoryCoordinateLocation){
  //
  Timer.periodic(new Duration(seconds: 10), (timer) {
    debugPrint(timer.tick.toString());
    LatLng currentLatLang = LatLng(0.0, 0.0);
    List<Map> allDistancesMap = [];
    for(LatLng singleInventoryCoordinate in inventoryCoordinateLocation){
      double distance = onCalculatorDistance(currentLatLang,singleInventoryCoordinate);
      allDistancesMap.add({'Latlng':singleInventoryCoordinate,'distance':distance});
    }
    //Find the closest distance
    MapEntry minDistanceMap = const MapEntry('somewhere', 1000);
    //Compare distance to the waitingDistance
    if(minDistanceMap.value <= maxWaitingDistance){
      //Popup dialog
      //Deliver man received
    }else{
      maxWaitingDistance += 1000;
    }
  });
}

onCalculatorDistance(LatLng firstLocation,LatLng secondLocation){
  double distance = 0.0;
  return distance;
}