import 'dart:io';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';

abstract class CdpsRemoteDataSource{
  Future<List<Cdp>> getNewCdps(String accessToken);
  Future<void> updateCdps(List<Cdp> cdps, String accessToken);
  Future<List<Cdp>> getOldCdps(String accessToken);
  Future<CdpsGroup> getCdps(String accessToken);
  Future<File> getFeaturePdf(Cdp feature, String accessToken);
}