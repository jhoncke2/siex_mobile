import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:siex/core/external/push_notifications_manager.dart';
import 'package:siex/core/external/shared_preferences_manager.dart';
import 'package:siex/features/authentication/data/data_sources/authentication_local_data_source.dart';
import 'package:siex/features/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:siex/features/authentication/external/data_sources/authentication_local_data_source_impl.dart';
import 'package:siex/features/authentication/external/data_sources/authentication_remote_data_source_impl.dart';
import 'package:siex/features/authentication/external/data_sources/fake/authentication_remote_data_source_fake.dart';
import 'package:siex/features/budgets/data/budgets_remote_data_source.dart';
import 'package:siex/features/budgets/data/budgets_repository_impl.dart';
import 'package:siex/features/budgets/domain/budgets_repository.dart';
import 'package:siex/features/budgets/domain/use_cases/get_budgets_impl.dart';
import 'package:siex/features/budgets/external/budgets_adapter.dart';
import 'package:siex/features/budgets/external/budgets_remote_data_source_impl.dart';
import 'package:siex/features/budgets/external/fake/budgets_remote_data_source_fake.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_bloc.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_budgets.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_cdps.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_budget.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_cdps.dart';
import 'core/domain/use_case_error_handler.dart';
import 'features/authentication/data/repository/authentication_repository_impl.dart';
import 'features/authentication/domain/repository/authentication_repository.dart';
import 'features/authentication/domain/use_cases/login.dart';
import 'features/authentication/domain/use_cases/logout.dart';
import 'features/authentication/external/data_sources/authentication_remote_adapter.dart';
import 'features/authentication/presentation/bloc/authentication_bloc.dart';
import 'features/authentication/presentation/use_cases/login.dart';
import 'features/authentication/presentation/use_cases/logout.dart';
import 'features/budgets/domain/use_cases/get_cdps_impl.dart';
import 'features/budgets/domain/use_cases/update_budget_impl.dart';
import 'features/budgets/domain/use_cases/update_cdps_impl.dart';
import 'features/init/domain/use_cases/there_is_authentication_impl.dart';
import 'features/init/presentation/bloc/init_bloc.dart';
import 'features/init/presentation/use_cases/there_is_authentication.dart';

const useRealData = false;
final sl = GetIt.instance;

Future<void> init()async{
  // Core
  final sharedPrefences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferencesManager>(
    () => SharedPreferencesManagerImpl(preferences: sharedPrefences)
  );
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin()
  );
  sl.registerLazySingleton<PushNotificationsManager>(
    () => PushNotificationsManagerImpl(
      localNotificationsPlugin: sl<FlutterLocalNotificationsPlugin>()
    )..initFirebase()
  );
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<UseCaseErrorHandler>(
    () => UseCaseErrorHandlerImpl(authenticationFixer: sl<AuthenticationRepository>())
  );

  // Budgets
  sl.registerLazySingleton<BudgetsAdapter>(
    () => BudgetsAdapter()
  );
  sl.registerLazySingleton<BudgetsRemoteDataSource>(
    () => _implementRealOrFake<BudgetsRemoteDataSource>(
      realImpl: BudgetsRemoteDataSourceImpl(
        client: sl<http.Client>(),
        adapter: sl<BudgetsAdapter>()
      ),
      fakeImpl: BudgetsRemoteDataSourceFake()
    )
  );
  sl.registerLazySingleton<BudgetsRepository>(
    () => BudgetsRepositoryImpl(
      remoteDataSource: sl<BudgetsRemoteDataSource>(),
      userExtraInfoGetter: sl<AuthenticationLocalDataSource>()
    )
  );
  sl.registerLazySingleton<GetBudgets>(
    () => GetBudgetsImpl(repository: sl<BudgetsRepository>())
  );
  sl.registerLazySingleton<UpdateBudget>(
    () => UpdateBudgetImpl(repository: sl<BudgetsRepository>())
  );
  sl.registerLazySingleton<GetCdps>(
    () => GetCdpsImpl(
      repository: sl<BudgetsRepository>(), 
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerLazySingleton<UpdateCdps>(
    () => UpdateCdpsImpl(
      repository: sl<BudgetsRepository>(), 
      errorHandler: sl<UseCaseErrorHandler>()
    )
  );
  sl.registerFactory<BudgetsBloc>(
    () => BudgetsBloc(
      getBudgets: sl<GetBudgets>(), 
      updateBudget: sl<UpdateBudget>(),
      getCdps: sl<GetCdps>(),
      updateCdps: sl<UpdateCdps>()      
    )
  );

  // Authentication
  sl.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSourceImpl(
      preferencesManager: sl<SharedPreferencesManager>(), 
      pushNotificationsTokenGetter: sl<PushNotificationsManager>()
    )
  );
  sl.registerLazySingleton<AuthenticationRemoteAdapter>(
    () => AuthenticationRemoteAdapterImpl()
  );
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => _implementRealOrFake<AuthenticationRemoteDataSource>(
      realImpl: AuthenticationRemoteDataSourceImpl(
        client: sl<http.Client>(), 
        adapter: sl<AuthenticationRemoteAdapter>()
      ),
      fakeImpl: AuthenticationRemoteDataSourceFake()
    )
  );
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      remoteDataSource: sl<AuthenticationRemoteDataSource>(), 
      localDataSource: sl<AuthenticationLocalDataSource>()
    )
  );
  sl.registerLazySingleton<Login>(
    () => LoginImpl(
      errorHandler: sl<UseCaseErrorHandler>(), 
      repository: sl<AuthenticationRepository>()
    )
  );
  sl.registerLazySingleton<Logout>(
    () => LogoutImpl(
      errorHandler: sl<UseCaseErrorHandler>(), 
      repository: sl<AuthenticationRepository>()
    )
  );
  sl.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(
      login: sl<Login>(), 
      logout: sl<Logout>()
    )
  );

  // ********** Init
  sl.registerLazySingleton<ThereIsAuthentication>(
    () => ThereIsAuthenticationImpl(accessTokenGetter: sl<AuthenticationLocalDataSource>())
  );
  sl.registerFactory<InitBloc>(
    () => InitBloc(thereIsAuthentication: sl<ThereIsAuthentication>())
  );
}

T _implementRealOrFake<T>({
  required T realImpl, 
  required T fakeImpl
}) => useRealData? realImpl
                 : fakeImpl;