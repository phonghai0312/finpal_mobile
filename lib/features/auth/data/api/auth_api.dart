import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'package:fridge_to_fork_ai/core/config/constant/api_base.dart';
import 'package:fridge_to_fork_ai/features/auth/data/models/login_model.dart';
import 'package:fridge_to_fork_ai/features/auth/data/models/register_model.dart';
import 'package:fridge_to_fork_ai/features/auth/data/models/refresh_token_model.dart';

part 'auth_api.g.dart';

@RestApi(baseUrl: ApiBaseDev.baseUrlDevelopment)
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<LoginModel> login(@Body() Map<String, dynamic> body);

  @POST('/auth/firebase/callback')
  Future<LoginModel> loginWithGoogle(@Body() Map<String, dynamic> body);

  @POST('/auth/register')
  Future<RegisterModel> register(@Body() Map<String, dynamic> body);

  @POST('/auth/forgot-password')
  Future<void> sendRequest(@Body() Map<String, dynamic> body);

  @POST('/auth/verify-otp')
  Future<void> verify(@Body() Map<String, dynamic> body);

  @POST('/auth/request-otp')
  Future<void> resendCode(@Body() Map<String, dynamic> body);

  @POST('/auth/reset-password')
  Future<void> resetPassword(@Body() Map<String, dynamic> body);

  @POST('/auth/refresh')
  Future<RefreshTokenModel> refreshToken();
}
