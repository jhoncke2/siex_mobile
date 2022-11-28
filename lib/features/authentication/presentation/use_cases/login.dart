import 'package:dartz/dartz.dart';
import 'package:siex/features/authentication/domain/entities/user.dart';
import 'package:siex/features/authentication/domain/failures/failures.dart';

abstract class Login{
  Future<Either<AuthenticationFailure, void>> call(User user);
}