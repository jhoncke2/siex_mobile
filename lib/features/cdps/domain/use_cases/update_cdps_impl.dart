import 'package:dartz/dartz.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import 'package:siex/features/cdps/presentation/use_cases/update_cdps.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../cdps_repository.dart';

class UpdateCdpsImpl implements UpdateCdps{
  final CdpsRepository repository;
  final UseCaseErrorHandler errorHandler;
  const UpdateCdpsImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<CdpsFailure, void>> call(List<Feature> cdps)async{
    return await errorHandler.executeFunction<CdpsFailure, void>(
      () => repository.updateCdps(cdps)
    );
  }
}