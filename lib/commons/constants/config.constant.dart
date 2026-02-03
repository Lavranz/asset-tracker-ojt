// Keys for jwt tokens in localStorage
import 'package:apollo_tracker_mobile/global-config.dart';

String authKey = 'ajs91zU398anv091n278';
final Uri _apiUrl = Uri.parse(apiUrl);
/* API URL
 */
String apiUrl = '${appConfig["apiUrl"]}';
String workConnectUrl = '${appConfig["workConnectUrl"]}';
/* CHANNEL
 */

String streamProtocol = _apiUrl.scheme == 'https' ? 'wss://' : 'ws://';
String streamUrl = '/stream/';
String apiStream =
    '$streamProtocol${_apiUrl.host}${_apiUrl.hasPort ? ':${_apiUrl.port}' : ''}$streamUrl';

String dateFormat = 'YYYY-MM-DD';