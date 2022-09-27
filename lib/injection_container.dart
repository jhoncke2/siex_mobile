import 'package:get_it/get_it.dart';
import 'package:siex/features/budgets/data/budgets_remote_data_source.dart';
import 'package:siex/features/budgets/data/budgets_repository_impl.dart';
import 'package:siex/features/budgets/domain/budgets_repository.dart';
import 'package:siex/features/budgets/domain/use_cases/get_budgets_impl.dart';
import 'package:siex/features/budgets/external/fake/budgets_remote_data_source_fake.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_bloc.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_budgets.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_budget.dart';
import 'features/budgets/domain/use_cases/update_budget_impl.dart';

final sl = GetIt.instance;
void init(){
  sl.registerLazySingleton<BudgetsRemoteDataSource>(
    () => BudgetsRemoteDataSourceFake()
  );
  sl.registerLazySingleton<BudgetsRepository>(
    () => BudgetsRepositoryImpl(remoteDataSource: sl<BudgetsRemoteDataSource>())
  );
  sl.registerLazySingleton<GetBudgets>(
    () => GetBudgetsImpl(repository: sl<BudgetsRepository>())
  );
  sl.registerLazySingleton<UpdateBudget>(
    () => UpdateBudgetImpl(repository: sl<BudgetsRepository>())
  );

  sl.registerFactory<BudgetsBloc>(
    () => BudgetsBloc(
      getBudgets: sl<GetBudgets>(), 
      updateBudget: sl<UpdateBudget>()
    )
  );
}