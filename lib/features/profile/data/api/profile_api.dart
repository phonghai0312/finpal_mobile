import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:finpal/core/config/constant/api_base.dart';
import 'package:finpal/features/profile/data/models/presigned_url_response_model.dart';
import 'package:finpal/features/profile/data/models/public_url_response_model.dart';
import 'package:finpal/features/profile/data/models/user_model.dart';

part 'profile_api.g.dart';

@RestApi(baseUrl: ApiBaseDev.baseUrlDevelopment)
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String? baseUrl}) = _ProfileApi;

  @GET('/users/me')
  Future<UserModel> getCurrentUser();

  @PATCH('/users/me/settings')
  Future<UserModel> updateUserSettings(@Body() Map<String, dynamic> body);

  @PUT('/users/update-profile')
  Future<UserModel> updateUserProfile(@Body() Map<String, dynamic> body);

  @POST('/auth/logout')
  Future<void> logout();

  @GET('/getPresignedUrl')
  Future<PresignedUrlResponseModel> getPresignedUrl(
    @Query('name') String fileName,
  );

  @GET('/getPublicUrl/public')
  Future<PublicUrlResponseModel> getPublicUrl(
    @Query('path') String filePath,
  );
}
