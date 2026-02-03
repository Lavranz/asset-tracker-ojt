import 'package:apollo_tracker_mobile/commons/services/agent-location.service.dart';
import 'package:apollo_tracker_mobile/commons/services/asset_tracker.service.dart';
import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:apollo_tracker_mobile/commons/services/toast.service.dart';
import 'package:apollo_tracker_mobile/commons/utils/helper.util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class AssetTrackingController extends ChangeNotifier
    with WidgetsBindingObserver {
  bool isTesting = false; // change this to true to test with dummy data
  bool dataReady = false; // checks if the data is ready to be submitted
  bool isSubmitting = false;
  bool permissionsGranted = false;
  bool permissionChecked = false;
  bool dialogShown = false;
  String scannedCode = "No code scanned";

  double? latitude;
  double? longitude;
  double? tolerance;
  dynamic originLocations;
  dynamic destinationLocations;
  dynamic allLocations;
  dynamic actions;
  dynamic devices;
  dynamic device;
  dynamic deviceId;
  dynamic deviceName;

  dynamic selectedAssetAction;
  dynamic origin;
  dynamic originId;
  dynamic originName;
  dynamic destination;
  dynamic destinationId;
  dynamic destinationName;
  dynamic currentLocationIds;

  BuildContext? context;

  /// ======================
  /// Lifecycle
  /// ======================
  void init(BuildContext ctx) {
    context = ctx;
    WidgetsBinding.instance.addObserver(this);
    requestPermissions();
  }

  void disposeController() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !permissionsGranted) {
      requestPermissions();
    }
  }

  /// ======================
  /// Permissions
  /// ======================
  Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final locationStatus = await Geolocator.requestPermission();

    permissionChecked = true;

    if (cameraStatus.isGranted &&
        (locationStatus == LocationPermission.always ||
            locationStatus == LocationPermission.whileInUse)) {
      permissionsGranted = true;
      dialogShown = false;
      notifyListeners();
    } else if (cameraStatus.isPermanentlyDenied ||
        locationStatus == LocationPermission.deniedForever) {
      await openAppSettings();
    } else {
      if (!dialogShown) {
        showPermissionDialog();
      }
    }
  }

  void showPermissionDialog() {
    dialogShown = true;

    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Permissions Required"),
        content: const Text(
          "Camera and Location access are required to use this app.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context!);
              dialogShown = false;
              await requestPermissions();
            },
            child: const Text("Grant Permissions"),
          ),
        ],
      ),
    );
  }

  /// ======================
  /// Location & API calls
  /// ======================
  Future<void> getCoordinates() async {
    dynamic coordinate;
    if (isTesting) {
      // apollo cdo current location
      longitude = 124.661102;
      latitude = 8.476608;
    } else {
      coordinate = await agentLocation$.getCurrentLocation();
      longitude = coordinate?.longitude;
      latitude = coordinate?.latitude;
    }
    notifyListeners();
  }

  Future<void> getLocation() async {
    if (isTesting) {
      currentLocationIds = List.generate(100, (index) => index + 1).toList();
    } else {
      originLocations = await assetTracker$.getLocation(
        longitude: longitude,
        latitude: latitude,
        tolerance: tolerance,
      );
      if (validData(originLocations)) {
        currentLocationIds = originLocations.map((e) => e['id']).toList();
        dataReady = true;
      } else {
        dataReady = false;
      }
    }
  }

  Future<void> getAllLocation() async {
    allLocations = await assetTracker$.getAllLocation();
  }

  Future<void> getActions(String code, dynamic currentLocationIds) async {
    dynamic actionMapList =
        await assetTracker$.getActions(code, currentLocationIds);
    if (validData(actionMapList)) {
      actions = actionMapList.map((e) => e['action']).toList();
      selectedAssetAction = actionMapList.first['action'];
      devices = actionMapList.first["device"];
      device = devices!.first;
      deviceId = devices!.first['id'];
      deviceName = devices!.first['productName'];

      originLocations = actionMapList.first["origin"];
      origin = originLocations!.first;
      originId = originLocations!.first['id'];
      originName = originLocations!.first['siteName'];

      if (validData(actionMapList.first["destination"])) {
        destinationLocations = actionMapList.first["destination"];
        destination = destinationLocations!.first;
        destinationId = destinationLocations!.first['id'];
        destinationName = destinationLocations!.first['siteName'];
      }

      dataReady = true;
    } else {
      dataReady = false;
    }
    notifyListeners();
  }

  /// ======================
  /// Scanner
  /// ======================
  void onDetect(BarcodeCapture capture) async {
    dynamic code;
    if (isTesting) {
      code = "AGC-C-00327,F7650F83F549";
    } else {
      code = capture.barcodes.first.rawValue;
    }

    if (validData(code)) {
      scannedCode = code;
      notifyListeners();

      await getCoordinates();
      await getLocation();
      await getActions(scannedCode, currentLocationIds);
    } else {
      dangerNativeToast("No code scanned");
      dataReady = false;
    }
    notifyListeners();
  }

  /// ======================
  /// Submit
  /// ======================
  Future<void> submitToWorkConnect() async {
    if (isSubmitting) return;

    if (dataReady) {
      isSubmitting = true;
      notifyListeners();
      dynamic data;
      if (isTesting) {
        data = {
          "device": device,
          "action": selectedAssetAction,
          if (validData(destination)) "destination": destination,
          "origin": origin,
          "accountId": 0,
          "actionBy": "Administrator",
          "actionTimestamp": DateTime.now().toIso8601String(),
        };
      } else {
        data = {
          "device": device,
          "action": selectedAssetAction,
          if (validData(destination)) "destination": destination,
          "origin": origin,
          "accountId": auth$.user?.agent.id ?? 0,
          "actionBy":
              "${auth$.currentUser?.firstName ?? 'Unknown Agent'} ${auth$.currentUser?.lastName}",
          "actionTimestamp": DateTime.now().toIso8601String(),
        };
      }

      await assetTracker$.submitActionToWorkConnect(data);
      resetDataAfterSuccessSubmission();
    }
  }

  void resetDataAfterSuccessSubmission() {
    dataReady = false;
    isSubmitting = false;
    notifyListeners();
  }

  void resetData() {
    dataReady = false;
    isSubmitting = false;
    notifyListeners();
  }
}
