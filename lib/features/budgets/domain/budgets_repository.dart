import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';

abstract class BudgetsRepository{
  Future<Either<BudgetsFailure, List<Budget>>> getBudgets();
  Future<Either<BudgetsFailure, void>> updateBudget(Budget budget);
  Future<Either<BudgetsFailure, List<Feature>>> getNewCdps();
  Future<Either<BudgetsFailure, void>> updateCdps(List<Feature> cdps);
  Future<Either<BudgetsFailure, CdpsGroup>> getCdps();
}