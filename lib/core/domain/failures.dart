import 'package:equatable/equatable.dart';
import 'package:gap_authorizations/core/domain/exceptions.dart';

class Failure extends Equatable{
  final String message;
  final AppException exception;
  const Failure({
    required this.message, 
    required this.exception
  });
  @override
  List<Object?> get props => [message, exception];
}