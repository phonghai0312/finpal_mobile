import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:fridge_to_fork_ai/core/config/constant/api_base.dart';
import 'package:fridge_to_fork_ai/features/profile/data/models/user_model.dart';

part 'profile_api.g.dart';

@RestApi(baseUrl: ApiBaseDev.baseUrlDevelopment)
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String? baseUrl}) = _ProfileApi;

  @GET('/users/me')
  Future<UserModel> getCurrentUser();

  @PATCH('/users/me/settings')
  Future<UserModel> updateUserSettings(@Body() Map<String, dynamic> body);
}
