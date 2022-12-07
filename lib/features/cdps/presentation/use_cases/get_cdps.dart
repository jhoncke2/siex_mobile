import 'package:dartz/dartz.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';

abstract class GetCdps{
  Future<Either<CdpsFailure, CdpsGroup>> call();
}