import 'package:siex/core/external/user_extra_info_getter.dart';
import 'package:siex/features/authentication/domain/entities/user.dart';

abstract class AuthenticationLocalDataSource implements UserExtraInfoGetter{
  Future<void> setUser(User user);
  Future<User> getUser();
  Future<void> setAccessToken(String accessToken);
  Future<void> resetApp();
  Future<String> getPushNotificationsToken();
}