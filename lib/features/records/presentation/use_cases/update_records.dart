import 'package:dartz/dartz.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import '../../domain/records_failure.dart';

abstract class UpdateRecords{
  Future<Either<RecordsFailure, void>> call(List<Record> records);
}