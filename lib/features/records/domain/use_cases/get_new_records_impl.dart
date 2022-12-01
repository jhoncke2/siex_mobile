import 'package:dartz/dartz.dart';
import 'package:siex/core/domain/use_case_error_handler.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/domain/records_failure.dart';
import 'package:siex/features/records/domain/records_repository.dart';
import 'package:siex/features/records/presentation/use_cases/get_new_records.dart';

class GetNewRecordsImpl implements GetNewRecords{
  final RecordsRepository repository;
  final UseCaseErrorHandler errorHandler;
  const GetNewRecordsImpl({
    required this.repository, 
    required this.errorHandler
  });
  
  @override
  Future<Either<RecordsFailure, List<Record>>> call()async{
    return await errorHandler.executeFunction<RecordsFailure, List<Record>>(
      () => repository.getNewRecords()
    );
  }

}