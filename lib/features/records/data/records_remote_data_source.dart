import 'package:siex/features/records/domain/entities/record.dart';

abstract class RecordsRemoteDataSource{
  Future<List<Record>> getNewRecords(String accessToken);
  Future<List<Record>> getOldRecords(String accessToken);
  Future<void> updateRecords(List<Record> records, String accessToken);
}