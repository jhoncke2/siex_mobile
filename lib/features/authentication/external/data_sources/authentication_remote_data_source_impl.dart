import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siex/core/domain/exceptions.dart';
import 'package:siex/features/authentication/domain/entities/user.dart';
import '../../../../core/external/remote_data_source.dart';
import '../../data/data_sources/authentication_remote_data_source.dart';
import 'authentication_remote_adapter.dart';

class AuthenticationRemoteDataSourceImpl extends RemoteDataSource implements AuthenticationRemoteDataSource{
  static const authBaseUrl = 'auth/';
  static const notificationsUrl = 'firebase/notification';
  final http.Client client;
  final AuthenticationRemoteAdapter adapter;
  AuthenticationRemoteDataSourceImpl({
    required this.client,
    required this.adapter
  });
  @override
  Future<String> login(User user)async{
    try{
      final response = await super.executeGeneralService(() async{
        final body = adapter.getStringJsonFromUser(user);
        return await client.post(
          super.getUri('${RemoteDataSource.baseApiUncodedPath}${authBaseUrl}login'),
          headers: createJsonContentTypeHeaders(),
          body: body
        );
      });
      return adapter.getAccessTokenFromResponse(response.body);
    }catch(exception){
      throw const ServerException(type: ServerExceptionType.LOGIN, message: 'Credenciales inválidas');
    }
  }
  
  @override
  Future<String> refreshAccessToken(String oldAccessToken)async{
    // TODO: implement refreshAccessToken
    throw UnimplementedError();
  }
  
  @override
  Future<int> getUserId(String accessToken)async{
    final result = await super.executeGeneralService(()async{
      return await client.post(
        super.getUri('${RemoteDataSource.baseApiUncodedPath}${authBaseUrl}me'),
        headers: createAuthorizationJsonHeaders(accessToken),
      );
    });
    return adapter.getIdFromResponse(result.body);
  }
  
  @override
  Future<void> setUserPushNotificationsToken(String accessToken, String pushNotificationsToken)async{
    await super.executeGeneralService(()async{
      return await client.post(
        super.getUri('${RemoteDataSource.baseApiUncodedPath}$notificationsUrl/device_token'),
        headers: createAuthorizationJsonHeaders(accessToken),
        body: jsonEncode({
          'device_token': pushNotificationsToken
        })
      );
    });
  }
  
  @override
  Future<void> logout(String accessToken)async{
    await super.executeGeneralService(()async{
      return await client.post(
        super.getUri('${RemoteDataSource.baseApiUncodedPath}${authBaseUrl}logout'),
        headers: createAuthorizationJsonHeaders(accessToken),
      );
    });
  }
}