import 'package:apollo_tracker_mobile/commons/constants/api.constant.dart';
import 'package:apollo_tracker_mobile/commons/services/toast.service.dart';
import 'package:apollo_tracker_mobile/commons/utils/http.util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AssetTrackerService extends ChangeNotifier {
  /// Fetch location with optional parameters
  Future<dynamic> getLocation({
    required double? longitude,
    required double? latitude,
    required double? tolerance,
  }) async {
    try {
      final response = await dio.get(
        apiWorkConnectGetLocation,
        queryParameters: {
          'longitude': longitude,
          'latitude': latitude,
          'tolerance': tolerance,
        },
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?.toString() ?? "Something went wrong";
      dangerNativeToast(message);
      return [];
    } catch (e) {
      dangerNativeToast(e.toString());
      return [];
    }
  }

  Future<dynamic> getAllLocation() async {
    try {
      final response = await dio.get(
        apiWorkConnectGetAllLocation,
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?.toString() ?? "Something went wrong";
      dangerNativeToast(message);
      return [];
    } catch (e) {
      dangerNativeToast(e.toString());
      return [];
    }
  }

Future<dynamic> getActions(
    String deviceCode,
    dynamic currentLocationIds,
  ) async {
    try {
      final response = await dio.get(
        apiWorkConnectGetActions,
        queryParameters: {
          'deviceCode': deviceCode,
          'currentLocationIds': currentLocationIds,
        },
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?.toString() ?? "Something went wrong";
      dangerNativeToast(message);
      return [];
    } catch (e) {
      dangerNativeToast(e.toString());
      return [];
    }
  }

  Future<dynamic> submitActionToWorkConnect(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        apiWorkConnectSubmitAction,
        data: data,
      );
      nativeToast(response.data);
    } on DioException catch (e) {
      final message = e.response?.data?.toString() ?? "Something went wrong";
      dangerNativeToast(message);
      return [];
    } catch (e) {
      dangerNativeToast(e.toString());
      return [];
    }
  }

  void change() {
    assetTracker$ = AssetTrackerService();
    notifyListeners();
  }
}

AssetTrackerService assetTracker$ = AssetTrackerService();
