import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';

abstract class GetCdpPdf{
  Future<Either<CdpsFailure, File>> call(Feature cdp);
}