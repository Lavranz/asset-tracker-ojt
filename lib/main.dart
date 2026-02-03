import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '/commons/services/location.service.dart';
import 'package:apollo_tracker_mobile/theme/base.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'dart:io'
    show HttpClient, HttpOverrides, SecurityContext, X509Certificate;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app_router.dart';
import 'reactive_form_config.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }

  await dotenv.load(fileName: ".env");

  await QueryClient.initialize(cachePrefix: 'fl-rt');

  runApp(const ProviderScope(child: MyApp()));
  FlutterNativeSplash.remove();
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationPermissionState = useState<PermissionStatus?>(null);
    final isLocationServiceInitialized = useState(false);

    useEffect(() {
      // Check if location permission is granted and initialize service
      Future<void> checkLocationPermission() async {
        if (!kIsWeb) {
          while (true) {
            final status = await Permission.location.status;

            // Proceed if permission is granted
            if (status.isGranted) {
              if (!isLocationServiceInitialized.value) {
                await LocationService.initializeService();
                isLocationServiceInitialized.value = true;
              }
              locationPermissionState.value = status;
              break; // Exit loop once permission is granted
            }

            // Wait and check again if permission is not granted
            await Future.delayed(const Duration(seconds: 5));
          }
        }
      }

      checkLocationPermission();

      return () {}; // Cleanup function (nothing to clean up for now)
    }, []);

    // Add lifecycle observer to handle app state changes
    useEffect(() {
      final appLifecycleObserver = _AppLifecycleObserver();
      WidgetsBinding.instance.addObserver(appLifecycleObserver);

      return () {
        WidgetsBinding.instance.removeObserver(appLifecycleObserver);
      };
    }, []);

    return QueryClientProvider(
      maxRetries: 1,
      child: ReactiveFormConfig(
        validationMessages: validationConfigs,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme.copyWith(
              textTheme:
                  GoogleFonts.interTextTheme(Theme.of(context).textTheme)),
          routerConfig: appRouter,
          title: 'Tracker',
        ),
      ),
    );
  }
}

// App lifecycle observer class to manage app state
class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // App is going to the background, stop location service
      if (!kIsWeb) {
        // Ensure location service is stopped only when app goes into background or is closed
        LocationService.stopService();
      }
    }
  }
}
