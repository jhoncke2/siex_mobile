import '../../../core/domain/failures.dart';

class CdpsFailure extends Failure{
  const CdpsFailure({
    required super.message,
    required super.exception
  });
}