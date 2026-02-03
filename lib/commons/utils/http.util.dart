import 'package:apollo_tracker_mobile/app_router.dart';
import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:apollo_tracker_mobile/commons/services/toast.service.dart';
import 'package:dio/dio.dart';
import './helper.util.dart';

String encodeURL(String url, [Map<String, dynamic>? data]) {
  if (data == null || objIsEmpty(data)) {
    return url;
  }

  data.removeWhere((key, value) => value == null);
  var params = data.entries
      .map((entry) =>
          '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
      .join('&');

  return '$url?$params';
}

String urlEncode(dynamic params, [Map<String, dynamic>? queries]) {
  String path;
  if (params is String) {
    path = params;
  } else if (params is List) {
    path = params
        .map((param) => param.toString().replaceAll(RegExp(r'/$'), ''))
        .join('/');
  } else {
    throw ArgumentError('params must be a String or a List');
  }

  if (queries != null) {
    return encodeURL('$path/', queries);
  }
  return encodeURL('$path/');
}

class DioClient {
  DioClient() {
    addInterceptor(ErrorInterceptor());
    addInterceptor(AuthInterceptor());
  }


  final Dio dio = Dio(BaseOptions(
    // validateStatus: (int? status) {
    //   return false;
    // },
  ));

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }
}

final dio = DioClient().dio;


class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode;
    final isValid = status != null && status >= 200 && status < 300;
    if (!isValid) {
      throw DioException.badResponse(
        statusCode: status!,
        requestOptions: response.requestOptions,
        response: response,
      );
    }
    super.onResponse(response, handler);
  }
}
// 
class AuthInterceptor implements Interceptor {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {

    if (await auth$.isAuthenticated()) {
      final token = await auth$.token();
      options.headers.addAll({"x-agent-code": "$token"});
    }

    return handler.next(options);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {

    if ((err.response == null) || err.response != null &&  err.response!.statusCode!  >= 500) {
      dangerNativeToast('Unexpected error occurred');
    }
    // Check if the response status code is 401
    if (err.response != null && err.response!.statusCode == 401) {
      // Implement your logout logic here
      await auth$.logout();
      appRouter.pushReplacement('/login');
    }
    return handler.next(err);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    return handler.next(response);
  }
}