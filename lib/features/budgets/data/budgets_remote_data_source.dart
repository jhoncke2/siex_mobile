import '../domain/entities/budget.dart';

abstract class BudgetsRemoteDataSource{
  Future<List<Budget>> getBudgets();
  Future<void> updateBudget(Budget budget);
}