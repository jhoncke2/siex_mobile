import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'budgets_failures.dart';

abstract class BudgetsRepository{
  Future<Either<BudgetsFailure, List<Budget>>> getBudgets();
  Future<Either<BudgetsFailure, void>> updateBudget(Budget budget);
}