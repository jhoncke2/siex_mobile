import 'package:dartz/dartz.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/domain/records_failure.dart';

abstract class GetNewRecords{
  Future<Either<RecordsFailure, List<Record>>> call();
}