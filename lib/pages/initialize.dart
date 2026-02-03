import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart'; // Import to use kIsWeb

class InitializePage extends HookWidget {
  const InitializePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _initializeApp(context);
      return null;
    }, []);

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _initializeApp(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasRestarted = prefs.getBool('hasRestarted') ?? false;

      // Check location permission
      final permissionStatus = await _checkAndRequestPermission(context);

      if (!permissionStatus) {
        return; // Permission denied, dialog already shown
      }

      // Check location services
      final servicesEnabled = await _checkLocationServices(context);

      if (!servicesEnabled) {
        return; // Location services not enabled, dialog already shown
      }

      // Handle app restart logic
      if (!hasRestarted) {
        await prefs.setBool('hasRestarted', true);
        await Restart.restartApp();
      } else {
        _navigateToLogin(context);
      }
    } catch (e) {
      // Handle any unexpected errors
      _showErrorDialog(
          context, 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<bool> _checkAndRequestPermission(BuildContext context) async {
    PermissionStatus permissionStatus = await Permission.location.status;

    if (permissionStatus.isGranted) {
      return true;
    }

    if (permissionStatus.isDenied) {
      permissionStatus = await Permission.location.request();

      if (permissionStatus.isGranted) {
        return true;
      }
    }

    // If permission is permanently denied, open app settings
    if (permissionStatus.isPermanentlyDenied) {
      _showLocationAlert(context);
      return false;
    }

    return false;
  }

  Future<bool> _checkLocationServices(BuildContext context) async {
    // Check if location services are enabled
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      await _promptHighAccuracy(context);
      return false;
    }

    // Skip accuracy check on web
    if (!kIsWeb) {
      // Check location accuracy only on non-web platforms
      try {
        LocationAccuracyStatus accuracyStatus =
            await Geolocator.getLocationAccuracy();

        if (accuracyStatus != LocationAccuracyStatus.precise) {
          await _promptHighAccuracy(context);
          return false;
        }
      } catch (e) {
        // Handle potential errors in checking location accuracy
        _showErrorDialog(context, 'Error checking location accuracy');
        return false;
      }
    }

    return true;
  }

  Future<void> _promptHighAccuracy(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('High-Accuracy Location Required'),
          content: const Text(
              'This app requires high-accuracy location services. Please enable them in your device settings.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'This app requires location permissions to function. Please enable them in your app settings.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToLogin(BuildContext context) {
    context.go('/login'); // Using the Go Router extension method
  }
}
