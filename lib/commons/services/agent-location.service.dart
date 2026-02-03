import 'package:apollo_tracker_mobile/commons/constants/api.constant.dart';
import 'package:apollo_tracker_mobile/commons/models/agent.model.dart';
import 'package:apollo_tracker_mobile/commons/models/attendance.model.dart';
import 'package:apollo_tracker_mobile/commons/utils/http.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:apollo_tracker_mobile/commons/utils/helper.util.dart';
import 'package:geolocator/geolocator.dart';

class AgentLocationService extends ChangeNotifier {

  Future<List<AgentLocation>> list() async {
    final res = await dio.get<dynamic>(
      apiAgentLocation
    );
    // Ensure the response data is a list and deserialize each item
    final data = (res.data as List<dynamic>).map((element) {
      return AgentLocation.fromJson(element);
    }).toList();

    return data;
  }

    // Get agent's current location
  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await handleLocationPermission();
    if (!hasPermission) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high));
      return position;
    } catch (e) {
      debugPrint("Error getting location: $e");
      return null;
    }
  }
}

AgentLocationService agentLocation$ = AgentLocationService();