import 'package:siex/core/external/remote_data_source.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import '../data/records_remote_data_source.dart';

class RecordsRemoteDataSourceImpl  extends RemoteDataSource implements RecordsRemoteDataSource{
  @override
  Future<List<Record>> getNewRecords(String accessToken)async{
    // TODO: implement getNewRecords
    throw UnimplementedError();
  }

  @override
  Future<List<Record>> getOldRecords(String accessToken)async{
    // TODO: implement getOldRecords
    throw UnimplementedError();
  }

  @override
  Future<void> updateRecords(List<Record> records, String accessToken)async{
    // TODO: implement updateRecords
    throw UnimplementedError();
  }

}