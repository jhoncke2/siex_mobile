import 'package:dartz/dartz.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_cdps.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../budgets_repository.dart';

class UpdateCdpsImpl implements UpdateCdps{
  final BudgetsRepository repository;
  final UseCaseErrorHandler errorHandler;
  const UpdateCdpsImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<BudgetsFailure, void>> call(List<Feature> cdps)async{
    return await errorHandler.executeFunction<BudgetsFailure, void>(
      () => repository.updateCdps(cdps)
    );
  }
}