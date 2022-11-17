import '../../../core/domain/failures.dart';

class BudgetsFailure extends Failure{
  const BudgetsFailure({
    required super.message,
    required super.exception
  });
}