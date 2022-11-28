import 'package:siex/core/domain/exceptions.dart';
import 'package:siex/core/domain/failures.dart';

class AuthenticationFailure extends Failure{
  const AuthenticationFailure({
    required String message, 
    required AppException exception
  }) : super(message: message, exception: exception);
}