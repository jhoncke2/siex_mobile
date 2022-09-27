import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/data/budgets_remote_data_source.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'package:siex/features/budgets/domain/budgets_repository.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';

class BudgetsRepositoryImpl implements BudgetsRepository{
  
  final BudgetsRemoteDataSource remoteDataSource;
  const BudgetsRepositoryImpl({
    required this.remoteDataSource
  });

  @override
  Future<Either<BudgetsFailure, List<Budget>>> getBudgets()async{
    final budgets = await remoteDataSource.getBudgets();
    return Right(budgets);
  }

  @override
  Future<Either<BudgetsFailure, void>> updateBudget(Budget budget)async{
    await remoteDataSource.updateBudget(budget);
    return const Right(null);
  }
}