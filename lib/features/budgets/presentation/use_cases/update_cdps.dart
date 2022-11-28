import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import '../../domain/entities/feature.dart';

abstract class UpdateCdps{
  Future<Either<BudgetsFailure, void>> call(List<Feature> cdps);
}