import 'dart:io';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';

abstract class CdpsRemoteDataSource{
  Future<List<Feature>> getNewCdps(String accessToken);
  Future<void> updateCdps(List<Feature> cdps, String accessToken);
  Future<List<Feature>> getOldCdps(String accessToken);
  Future<CdpsGroup> getCdps(String accessToken);
  Future<File> getFeaturePdf(Feature feature, String accessToken);
}