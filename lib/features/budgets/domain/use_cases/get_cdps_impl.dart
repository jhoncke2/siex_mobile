import 'package:dartz/dartz.dart';
import 'package:siex/core/domain/use_case_error_handler.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import '../../presentation/use_cases/get_cdps.dart';
import '../budgets_repository.dart';

class GetCdpsImpl implements GetCdps{
  final BudgetsRepository repository;
  final UseCaseErrorHandler errorHandler;
  const GetCdpsImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<BudgetsFailure, CdpsGroup>> call()async{
    return await errorHandler.executeFunction<BudgetsFailure, CdpsGroup>(
      () => repository.getCdps()
    );
  }
  
}