import 'package:dartz/dartz.dart';
import 'package:siex/core/external/user_extra_info_getter.dart';
import 'package:siex/features/budgets/data/budgets_remote_data_source.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'package:siex/features/budgets/domain/budgets_repository.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import '../../../core/domain/exceptions.dart';

class BudgetsRepositoryImpl implements BudgetsRepository{
  
  final BudgetsRemoteDataSource remoteDataSource;
  final UserExtraInfoGetter userExtraInfoGetter;
  const BudgetsRepositoryImpl({
    required this.remoteDataSource,
    required this.userExtraInfoGetter
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

  @override
  Future<Either<BudgetsFailure, List<Feature>>> getNewCdps()async{
    final accessToken = await userExtraInfoGetter.getAccessToken();
    final cdps = await remoteDataSource.getNewCdps(accessToken);
    return Right(cdps);
  }

  @override
  Future<Either<BudgetsFailure, void>> updateCdps(List<Feature> cdps)async{
    return await _manageFunctionExceptions<void>(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      await remoteDataSource.updateCdps(cdps, accessToken);
      return const Right(null);
    });
  }

  @override
  Future<Either<BudgetsFailure, CdpsGroup>> getCdps()async{
    return await _manageFunctionExceptions<CdpsGroup>(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final cdps = await remoteDataSource.getCdps(accessToken);
      return Right(cdps);
    });
    
  }

  Future<Either<BudgetsFailure, T>> _manageFunctionExceptions<T>(
    Future<Either<BudgetsFailure, T>> Function() function
  )async{
    try{
      return await function();
    }on AppException catch(exception){
      return Left(BudgetsFailure(
        message: exception.message??'',
        exception: exception
      ));
    }catch(exception, stackTrace){
      print(stackTrace);
      return const Left(BudgetsFailure(
        message: '',
        exception: AppException('')
      ));
    }
  }
}