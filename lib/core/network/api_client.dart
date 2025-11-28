import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    // 1. Logging
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

    // 2. Unwrap { "data": {...} } -> { ... }
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final data = response.data;

          // Nếu response là Map và có key "data"
          if (data is Map<String, dynamic> && data['data'] != null) {
            // print để debug nếu muốn
            // debugPrint('[ApiClient] unwrap data: ${data['data']}');
            response.data = data['data'];
          }

          handler.next(response);
        },
      ),
    );

    // 3. Attach JWT từ SharedPreferences
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final path = options.path;

          // Bỏ qua auth cho login/register
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
