import 'package:siex/features/authentication/domain/entities/user.dart';

abstract class AuthenticationRemoteDataSource{
  Future<String> login(User user);
  Future<String> refreshAccessToken(String oldAccessToken);
  Future<int> getUserId(String accessToken);
  Future<void> setUserPushNotificationsToken(String accessToken, String pushNotificationsToken);
  Future<void> logout(String accessToken);
}