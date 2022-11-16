import 'package:equatable/equatable.dart';

class AppException extends Equatable{
  final String? message;
  const AppException(this.message);
  @override
  List<Object?> get props => [message];
}

enum StorageExceptionType{
  EMPTYDATA,
  NORMAL
}

class StorageException extends AppException{
  final StorageExceptionType type;
  const StorageException({
    required String message, 
    required this.type
  }): super(
    message
  );
  @override
  List<Object?> get props => [message, type];
}

enum ServerExceptionType{
  LOGIN,
  REFRESH_ACCESS_TOKEN,
  UNHAUTORAIZED,
  NORMAL
}

class ServerException extends AppException{
  final ServerExceptionType type;
  const ServerException({
    required this.type,
    String message = ''
  }): super(message);
  @override
  List<Object?> get props => [...super.props, type];
}
