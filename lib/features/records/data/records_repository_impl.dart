import 'package:dartz/dartz.dart';
import 'package:siex/core/external/user_extra_info_getter.dart';
import 'package:siex/features/records/data/records_remote_data_source.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/domain/records_failure.dart';
import 'package:siex/features/records/domain/records_repository.dart';
import '../../../core/domain/exceptions.dart';

class RecordsRepositoryImpl implements RecordsRepository{
  final RecordsRemoteDataSource remoteDataSource;
  final UserExtraInfoGetter userExtraInfoGetter;
  const RecordsRepositoryImpl({
    required this.remoteDataSource, 
    required this.userExtraInfoGetter
  });
  
  @override
  Future<Either<RecordsFailure, List<Record>>> getNewRecords()async{
    return await _manageFunctionExceptions<List<Record>>(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final records = await remoteDataSource.getNewRecords(accessToken);
      return Right(records);
    });
  }

  @override
  Future<Either<RecordsFailure, List<Record>>> getOldRecords()async{
    return await _manageFunctionExceptions<List<Record>>(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final records = await remoteDataSource.getOldRecords(accessToken);
      return Right(records);
    });
  }

  @override
  Future<Either<RecordsFailure, void>> updateRecords(List<Record> records)async{
    return await _manageFunctionExceptions<void>(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      await remoteDataSource.updateRecords(records, accessToken);
      return const Right(null);
    });
  }

  Future<Either<RecordsFailure, T>> _manageFunctionExceptions<T>(
    Future<Either<RecordsFailure, T>> Function() function
  )async{
    try{
      return await function();
    }on AppException catch(exception){
      return Left(RecordsFailure(
        message: exception.message??'',
        exception: exception
      ));
    }catch(exception, stackTrace){
      return const Left(RecordsFailure(
        message: '',
        exception: AppException('')
      ));
    }
  }

}