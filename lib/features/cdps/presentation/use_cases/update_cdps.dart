import 'package:dartz/dartz.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import '../../domain/entities/cdp.dart';

abstract class UpdateCdps{
  Future<Either<CdpsFailure, void>> call(List<Cdp> cdps);
}