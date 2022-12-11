import 'package:dartz/dartz.dart';
import 'package:siex/core/domain/use_case_error_handler.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import '../../presentation/use_cases/get_cdps.dart';
import '../cdps_repository.dart';

class GetCdpsImpl implements GetCdps{
  final CdpsRepository repository;
  final UseCaseErrorHandler errorHandler;
  const GetCdpsImpl({
    required this.repository,
    required this.errorHandler
  });
  @override
  Future<Either<CdpsFailure, CdpsGroup>> call()async{
    return await errorHandler.executeFunction<CdpsFailure, CdpsGroup>(
      () => repository.getCdps()
    );
  }
  
}