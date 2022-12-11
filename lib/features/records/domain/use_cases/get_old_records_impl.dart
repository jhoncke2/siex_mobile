import 'package:dartz/dartz.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/domain/records_failure.dart';
import 'package:siex/features/records/presentation/use_cases/get_old_records.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../records_repository.dart';

class GetOldRecordsImpl implements GetOldRecords{

  final RecordsRepository repository;
  final UseCaseErrorHandler errorHandler;
  const GetOldRecordsImpl({
    required this.repository, 
    required this.errorHandler
  });

  @override
  Future<Either<RecordsFailure, List<Record>>> call()async{
    return await errorHandler.executeFunction<RecordsFailure, List<Record>>(
      () => repository.getOldRecords()
    );
  }

}