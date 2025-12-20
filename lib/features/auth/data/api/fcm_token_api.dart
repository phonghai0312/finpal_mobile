import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'package:fridge_to_fork_ai/features/auth/data/models/fcm_token_model.dart';
import 'package:fridge_to_fork_ai/core/config/constant/api_base.dart';

part 'fcm_token_api.g.dart';

@RestApi(baseUrl: ApiBaseNotiDev.baseUrlNotification)
abstract class FcmTokenApi {
  factory FcmTokenApi(Dio dio, {String? baseUrl}) = _FcmTokenApi;

  @POST('/token')
  Future<FcmTokenModel> registerToken(@Body() Map<String, dynamic> body);

  @POST('/token/deactive')
  Future<void> deactiveToken(@Body() Map<String, dynamic> body);
}



