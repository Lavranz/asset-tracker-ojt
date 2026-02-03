import 'package:apollo_tracker_mobile/commons/constants/api.constant.dart';
import 'package:apollo_tracker_mobile/commons/models/attendance.model.dart';
import 'package:apollo_tracker_mobile/commons/models/ticket.model.dart';
import 'package:apollo_tracker_mobile/commons/utils/http.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AttendanceService extends ChangeNotifier {

  Future checkIn(dynamic data) async {
    final res = await dio.post<dynamic>(
      apiAttendanceCheckIn,
      data: data
    );

    return res.data;
  }

  Future<TimeOutResponse> checkOut(dynamic data) async {
    final res = await dio.post<dynamic>(
      apiAttendanceCheckOut,
      data: data
    );
    return TimeOutResponse.fromJson(res.data);
  }

  Future<AttendanceCheck> check() async {
    final res = await dio.get<dynamic>(
      apiAttendanceCheck
    );
    return AttendanceCheck.fromJson(res.data);
  }

  Future<List<AttendanceWeekLog>> getWeekLogs() async {
    final res = await dio.get<dynamic>(
      apiAttendanceWeekLogs
    );
    // Ensure the response data is a list and deserialize each item
    final data = (res.data as List<dynamic>).map((element) {
      return AttendanceWeekLog.fromJson(element);
    }).toList();

    return data;
  }

  change(){
    attendance$ = AttendanceService();
  }
}

AttendanceService attendance$ = AttendanceService();