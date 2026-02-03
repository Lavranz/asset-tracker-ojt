class AttendanceCheck {
  final String statusCode;
  final String statusMessage;
  final AttendanceData data;

  AttendanceCheck({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
  });

  // Factory method to parse JSON
  factory AttendanceCheck.fromJson(Map<String, dynamic> json) {
    return AttendanceCheck(
      statusCode: json['status']['code'].toString(),
      statusMessage: json['status']['message'],
      data: AttendanceData.fromJson(json['data']),
    );
  }
}

class AttendanceData {
  final bool timeIn;
  String? time;

  AttendanceData({
    required this.timeIn,
    this.time,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      timeIn: json['time_in'],
      time: json['time'],  // Just a string, no formatting needed
    );
  }
}

class TimeOutResponse {
  final int statusCode;
  final String responseMessage;
  final String logoutTime;
  final String hoursWorked;

  TimeOutResponse({
    required this.statusCode,
    required this.responseMessage,
    required this.logoutTime,
    required this.hoursWorked,
  });

  // Factory method to parse JSON
  factory TimeOutResponse.fromJson(Map<String, dynamic> json) {
    return TimeOutResponse(
      statusCode: json['status']['code'],
      responseMessage: json['status']['response'],
      logoutTime: json['status']['time'],
      hoursWorked: json['status']['hours_worked'],
    );
  }
}


class AttendanceWeekLog {
  final String timeIn;
  final String timeOut;
  final String duration;

  AttendanceWeekLog({
    required this.timeIn,
    required this.timeOut,
    required this.duration,
  });

  // Factory method to parse JSON
  factory AttendanceWeekLog.fromJson(Map<String, dynamic> json) {
    return AttendanceWeekLog(
      duration: json['duration'],
      timeIn: json['time_in'],
      timeOut: json['time_out'],
    );
  }
}
