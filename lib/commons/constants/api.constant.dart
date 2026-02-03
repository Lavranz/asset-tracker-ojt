import 'package:apollo_tracker_mobile/commons/constants/config.constant.dart';
import 'package:apollo_tracker_mobile/commons/utils/http.util.dart';

// user
String apiAuthLogin = urlEncode([apiUrl, 'mobile_login']);
String apiWorkConnectGetLocation = urlEncode([workConnectUrl, 'api/poc/get/location-by-coordinates']);
String apiWorkConnectGetAllLocation = urlEncode([workConnectUrl, 'api/poc/get/all-locations']);
String apiWorkConnectGetActions = urlEncode([workConnectUrl, 'api/poc/get/actions']);
String apiWorkConnectSubmitAction = urlEncode([workConnectUrl, 'api/poc/post/save-asset-action']);
// String apiWorkConnectGetLocation = urlEncode(['http://localhost:8080/', 'api/poc/get/location-by-coordinates']);
// String apiWorkConnectGetAllLocation = urlEncode(['http://localhost:8080/', 'api/poc/get/all-locations']);
// String apiWorkConnectGetActions = urlEncode(['http://localhost:8080/', 'api/poc/get/actions']);
// String apiWorkConnectSubmitAction = urlEncode(['http://localhost:8080/', 'api/poc/post/save-asset-action']);

String apiAuthLogout = urlEncode([apiUrl, 'mobile/logout']);
String apiAuth = urlEncode([apiUrl, 'api/auth']);

String apiTicketList = urlEncode([apiUrl, 'api/tickets']);
String apiTicketListStat = urlEncode([apiUrl, 'api/tickets/stats']);

// attendance api 
String apiAttendance = urlEncode([apiUrl, 'api/attendance']);
String apiAttendanceCheckIn = urlEncode([apiAttendance, 'agent/check-in']);
String apiAttendanceCheckOut = urlEncode([apiAttendance, 'agent/check-out']);
String apiAttendanceCheck = urlEncode([apiAttendance, 'agent/check']);
String apiAttendanceWeekLogs = urlEncode([apiAttendance, 'week-logs']);

// agent api 
String apiAgent = urlEncode([apiUrl, 'api/agent/']);
String apiAgentLocation = urlEncode([apiAgent, 'location']);

// fsr api
String apiFSR = urlEncode([apiUrl, 'api/fsr']);
String apiFSRTickets = urlEncode([apiFSR, 'tickets']);