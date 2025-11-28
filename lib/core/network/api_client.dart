import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    // Logging
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    // Attach JWT from SharedPreferences for authenticated calls
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Skip auth header for login/register if needed
          final path = options.path;
          if (path.startsWith('/auth/login') ||
              path.startsWith('/auth/register')) {
            return handler.next(options);
          }

          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          if (token != null && token.isNotEmpty) {
            options.headers['x-access-token'] = token;
          }

          handler.next(options);
        },
      ),
    );
  }

  T create<T>(
    T Function(Dio dio, {String? baseUrl}) createFn, {
    String? baseUrl,
  }) {
    return createFn(_dio, baseUrl: baseUrl);
  }
}
