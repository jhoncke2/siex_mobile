import '../../../core/domain/failures.dart';

class RecordsFailure extends Failure{
  const RecordsFailure({
    required super.message,
    required super.exception
  });
}