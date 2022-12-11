import 'package:siex/features/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:siex/features/authentication/domain/entities/user.dart';

class AuthenticationRemoteDataSourceFake implements AuthenticationRemoteDataSource{
  @override
  Future<String> login(User user)async{
    return 'the_access_token_xyz';
  }

  @override
  Future<String> refreshAccessToken(String oldAccessToken)async{
    return '${oldAccessToken.substring(0, (oldAccessToken.length/2).ceil())}new_acc_token';
  }
  
  @override
  Future<int> getUserId(String accessToken)async{
    return 0;
  }
  
  @override
  Future<void> setUserPushNotificationsToken(String accessToken, String pushNotificationsToken)async{
    print('********************* push notifications token ****************************');
    print(pushNotificationsToken);
  }
  
  @override
  Future<void> logout(String accessToken)async{
    await Future.delayed(const Duration(
      milliseconds: 750
    ));
  }
}