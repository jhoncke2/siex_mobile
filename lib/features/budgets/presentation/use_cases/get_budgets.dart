import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';

import '../../domain/entities/budget.dart';

abstract class GetBudgets{
  Future<Either<BudgetsFailure, List<Budget>>> call();
}