import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';

abstract class CdpsRepository{
  Future<Either<CdpsFailure, List<Cdp>>> getNewCdps();
  Future<Either<CdpsFailure, void>> updateCdps(List<Cdp> cdps);
  Future<Either<CdpsFailure, CdpsGroup>> getCdps();
  Future<Either<CdpsFailure, File>> getCdpPdf(Cdp cdp);
}