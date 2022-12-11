import 'package:dartz/dartz.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/domain/records_failure.dart';

abstract class RecordsRepository{
  Future<Either<RecordsFailure, List<Record>>> getNewRecords();
  Future<Either<RecordsFailure, List<Record>>> getOldRecords();
  Future<Either<RecordsFailure, void>> updateRecords(List<Record> records);
}