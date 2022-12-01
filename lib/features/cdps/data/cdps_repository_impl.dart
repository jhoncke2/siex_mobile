import 'package:dartz/dartz.dart';
import 'package:siex/core/external/user_extra_info_getter.dart';
import 'package:siex/features/cdps/data/cdps_remote_data_source.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import 'package:siex/features/cdps/domain/cdps_repository.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';
import '../../../core/domain/exceptions.dart';

class CdpsRepositoryImpl implements CdpsRepository{
  
  final CdpsRemoteDataSource remoteDataSource;
  final UserExtraInfoGetter userExtraInfoGetter;
  const CdpsRepositoryImpl({
    required this.remoteDataSource,
    required this.userExtraInfoGetter
  });

  @override
  Future<Either<CdpsFailure, List<Cdp>>> getNewCdps()async{
    final accessToken = await userExtraInfoGetter.getAccessToken();
    final cdps = await remoteDataSource.getNewCdps(accessToken);
    return Right(cdps);
  }

  @override
  Future<Either<CdpsFailure, void>> updateCdps(List<Cdp> cdps)async{
    return await _manageFunctionExceptions<void>(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      await remoteDataSource.updateCdps(cdps, accessToken);
      return const Right(null);
    });
  }

  @override
  Future<Either<CdpsFailure, CdpsGroup>> getCdps()async{
    return await _manageFunctionExceptions<CdpsGroup>(()async{
      final accessToken = await userExtraInfoGetter.getAccessToken();
      final cdps = await remoteDataSource.getCdps(accessToken);
      return Right(cdps);
    });
    
  }

  Future<Either<CdpsFailure, T>> _manageFunctionExceptions<T>(
    Future<Either<CdpsFailure, T>> Function() function
  )async{
    try{
      return await function();
    }on AppException catch(exception){
      return Left(CdpsFailure(
        message: exception.message??'',
        exception: exception
      ));
    }catch(exception, stackTrace){
      print(stackTrace);
      return const Left(CdpsFailure(
        message: '',
        exception: AppException('')
      ));
    }
  }
}