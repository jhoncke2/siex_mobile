import 'package:dartz/dartz.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';

abstract class CdpsRepository{
  Future<Either<CdpsFailure, List<Feature>>> getNewCdps();
  Future<Either<CdpsFailure, void>> updateCdps(List<Feature> cdps);
  Future<Either<CdpsFailure, CdpsGroup>> getCdps();
}