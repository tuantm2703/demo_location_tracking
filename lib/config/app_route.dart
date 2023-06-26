import 'package:demo_location_tracking/screen/delivery_order_screen.dart';
import 'package:demo_location_tracking/screen/location_tracking_screen.dart';
import 'package:demo_location_tracking/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes{
  static String splash = '/splash';
  static String locationTracking = '/locationTracking';
  static String deliveryOrder = '/deliveryOrder';

  static Route<dynamic>? getRoutes(RouteSettings settings) {
    if (settings.name == splash) {
      return _buildRoute(settings, const SplashScreen());
    } else if(settings.name == locationTracking){
      return _buildRoute(settings, const LocationTrackingScreen());
    } else if(settings.name == deliveryOrder){
      return _buildRoute(settings, const DeliveryOrderScreen());
    }
    return null;
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => builder,
    );
  }
}