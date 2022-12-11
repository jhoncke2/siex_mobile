import 'package:siex/features/records/data/records_remote_data_source.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import './fake_records.dart';

class RecordsRemoteDataSourceFake implements RecordsRemoteDataSource{

  @override
  Future<List<Record>> getNewRecords(String accessToken)async{
    await Future.delayed(const Duration(milliseconds: 750));
    return newRecords;
  }

  @override
  Future<List<Record>> getOldRecords(String accessToken)async{
    await Future.delayed(const Duration(milliseconds: 1000));
    return oldRecords;
  }

  @override
  Future<void> updateRecords(List<Record> records, String accessToken)async{
    await Future.delayed(const Duration(milliseconds: 250));
    final updatedRecordsIds = records.where(
      (r) => r.state != null
    ).map<int>(
      (r) => r.id
    ).toList();
    oldRecords.removeWhere(
      (record) => updatedRecordsIds.contains(record.id)
    );
  }

}