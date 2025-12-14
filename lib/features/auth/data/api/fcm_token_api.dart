import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'package:fridge_to_fork_ai/features/auth/data/models/fcm_token_model.dart';

part 'fcm_token_api.g.dart';

@RestApi(baseUrl: 'http:// 192.168.225.60:3002')
abstract class FcmTokenApi {
  factory FcmTokenApi(Dio dio, {String? baseUrl}) = _FcmTokenApi;

  @POST('/token')
  Future<FcmTokenModel> registerToken(@Body() Map<String, dynamic> body);
}



