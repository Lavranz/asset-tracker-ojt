import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:apollo_tracker_mobile/controllers/asset_tracker_controller.dart';

class AssetTrackingPage extends StatefulWidget {
  const AssetTrackingPage({super.key});

  @override
  State<AssetTrackingPage> createState() => _AssetTrackingPageState();
}

class _AssetTrackingPageState extends State<AssetTrackingPage> {
  late AssetTrackingController controller;

  @override
  void initState() {
    super.initState();
    controller = AssetTrackingController();
    controller.init(context);
  }

  @override
  void dispose() {
    controller.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<AssetTrackingController>(builder: (_, c, __) {
          if (!c.permissionsGranted) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(title: const Text("Asset Tracker")),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!c.dataReady) ...[
                    Expanded(
                      flex: 3,
                      child: MobileScanner(onDetect: c.onDetect),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Scan the device's QR Code / Bar Code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ] else ...[
                    // Code here for logic after scanning the code

                  ]
                ],
              ),
            ),
          );
        }));
  }
}
