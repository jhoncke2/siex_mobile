import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';

abstract class GetCdps{
  Future<Either<BudgetsFailure, CdpsGroup>> call();
}