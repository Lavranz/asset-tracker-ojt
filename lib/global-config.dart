import 'package:flutter_dotenv/flutter_dotenv.dart';

final appConfig = {'apiUrl': dotenv.env['API_URL'], 
                  'workConnectUrl': dotenv.env['WORKCONNECT_API_URL']
                  };