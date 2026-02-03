import 'dart:ui';
import 'package:apollo_tracker_mobile/commons/utils/http.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:apollo_tracker_mobile/commons/constants/api.constant.dart';
import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:apollo_tracker_mobile/commons/utils/helper.util.dart';

class LocationService {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart, // Ensure only lightweight initialization here
        isForegroundMode: true,
        autoStart: true,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStart,
        onBackground: null, // iOS doesn't allow isolated background services
      ),
    );

    service.startService();
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // Ensure background plugins don't cause issues.
    DartPluginRegistrant.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();

    dotenv.load(fileName: '.env');

    // Handle foreground and background events
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    // Ensure the service remains alive
    service.on('stop').listen((event) {
      service.stopSelf();
    });
    

    // Background location tracking logic
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    DateTime?
        lastUpdateTime; // Variable to store the timestamp of the last update

    Geolocator.getPositionStream().listen((Position position) async {
      final now = DateTime.now();

      // Send update only if 20 seconds have passed since the last update
      if (lastUpdateTime == null ||
          now.difference(lastUpdateTime!) > Duration(seconds: 20)) {
        lastUpdateTime = now;

        if (await auth$.isAuthenticated()) {
          final data = {
            'latitude': position.latitude.toString(),
            'longitude': position.longitude.toString(),
            'accuracy': position.accuracy.toString(),
            'hardwareId': await getDeviceId(),
          };

          await _updateLocation(data);
        }
      }
    });
  }

  // Method to stop the service externally
  static Future<void> stopService() async {
    final service = FlutterBackgroundService();
    service.invoke('stop');
  }

  static Future<dynamic> _updateLocation(Map<String, dynamic> data) async {
    final res = await dio.put<Map<String, dynamic>>(
      apiAgentLocation,
      data: data,
    );
    return res.data;
  }
}
