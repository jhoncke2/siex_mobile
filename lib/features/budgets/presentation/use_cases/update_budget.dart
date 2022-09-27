import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';

abstract class UpdateBudget{
  Future<Either<BudgetsFailure, void>> call(Budget budget);
}