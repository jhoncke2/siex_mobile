import 'package:siex/features/budgets/domain/budgets_repository.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_budgets.dart';

class GetBudgetsImpl implements GetBudgets{
  final BudgetsRepository repository;
  const GetBudgetsImpl({
    required this.repository
  });
  @override
  Future<Either<BudgetsFailure, List<Budget>>> call()async{
    return await repository.getBudgets();
  }

}