import 'package:demo_location_tracking/screen/location_tracking_screen.dart';
import 'package:demo_location_tracking/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes{
  static String splash = '/splash';
  static String locationTracking = '/locationTracking';

  static Route<dynamic>? getRoutes(RouteSettings settings) {
    if (settings.name == splash) {
      return _buildRoute(settings, const SplashScreen());
    } else if(settings.name == locationTracking){
      return _buildRoute(settings, const LocationTrackingScreen());
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