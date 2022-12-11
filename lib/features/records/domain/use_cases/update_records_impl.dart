import 'package:dartz/dartz.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/domain/records_failure.dart';
import 'package:siex/features/records/presentation/use_cases/update_records.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../records_repository.dart';

class UpdateRecordsImpl implements UpdateRecords{
  final RecordsRepository repository;
  final UseCaseErrorHandler errorHandler;
  const UpdateRecordsImpl({
    required this.repository, 
    required this.errorHandler
  });
  
  @override
  Future<Either<RecordsFailure, void>> call(List<Record> records)async{
    return await errorHandler.executeFunction<RecordsFailure, void>(
      () => repository.updateRecords(records)
    );
  }
}