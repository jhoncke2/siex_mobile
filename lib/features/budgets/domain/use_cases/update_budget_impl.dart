import 'package:siex/features/budgets/domain/budgets_repository.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_budget.dart';

class UpdateBudgetImpl implements UpdateBudget{
  final BudgetsRepository repository;
  const UpdateBudgetImpl({
    required this.repository
  });
  @override
  Future<Either<BudgetsFailure, void>> call(Budget budget)async{
    return await repository.updateBudget(budget);
  }

}