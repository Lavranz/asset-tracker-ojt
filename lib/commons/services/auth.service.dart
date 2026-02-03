import 'package:apollo_tracker_mobile/commons/constants/api.constant.dart';
import 'package:apollo_tracker_mobile/commons/constants/config.constant.dart';
import 'package:apollo_tracker_mobile/commons/models/agent.model.dart';
import 'package:apollo_tracker_mobile/commons/models/users.model.dart';
import 'package:apollo_tracker_mobile/commons/utils/http.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _AuthService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  LoginResult? user;

  Future<LoginResult> login(dynamic data) async {
    final res = await dio.post<dynamic>(
      apiAuthLogin,
      data: data,
    );
    final userData = LoginResult.fromJson(res.data);
    user = userData;
    return userData;
  }

  AgentAuth? currentUser; 
  Future<AgentAuth> getUser() async {
    final res = await dio.get<dynamic>(
      apiAuth,
    );

    final userAuth = AgentAuth.fromJson(res.data);
    currentUser = userAuth;

    return userAuth;
  }

  Future<void> setToken(String value) async {
    await _storage.write(key: authKey, value: value);
  }

  Future<String?> token() async {
    try {
      final value = await _storage.read(key: authKey);
      return value;
    } catch (e) {
      debugPrint("Error reading secure storage: $e");
      // Optional: Clear storage if a decryption error occurs
      await _storage.deleteAll();
      return null;
    }
  }
  
  Future<bool> isAuthenticated() async {
    return await token() != null;
  }

  Future logout() async {
    dio.post(
      apiAuthLogout,
    );
    await _storage.delete(key: authKey);
  }
  change(){
    auth$ = _AuthService();
  }
}

_AuthService auth$ = _AuthService();