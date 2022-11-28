import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:siex/core/domain/exceptions.dart';
import 'package:siex/core/external/user_extra_info_getter.dart';
import 'package:siex/features/cdps/data/cdps_remote_data_source.dart';
import 'package:siex/features/cdps/data/cdps_repository_impl.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';
import 'budgets_repository_impl_test.mocks.dart';

late CdpsRepositoryImpl budgetsRepository;
late MockCdpsRemoteDataSource remoteDataSource;
late MockUserExtraInfoGetter userExtraInfoGetter;

@GenerateMocks([
  CdpsRemoteDataSource,
  UserExtraInfoGetter
])
void main(){
  setUp((){
    userExtraInfoGetter = MockUserExtraInfoGetter();
    remoteDataSource = MockCdpsRemoteDataSource();
    budgetsRepository = CdpsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      userExtraInfoGetter: userExtraInfoGetter
    );
  });

  group('get cdps', _testGetCdpsGroup);
  group('update cdps', _testUpdateCdpsGroup);
}

void _testGetCdpsGroup(){
  late String tAccessToken;
  
  setUp((){
    tAccessToken = 'access_token';
    when(userExtraInfoGetter.getAccessToken())
        .thenAnswer((_) async => tAccessToken);
  });

  group('when all goes good', (){
    late CdpsGroup tCdps;
    setUp((){
      tCdps = CdpsGroup(
        newCdps: [
          Feature(
            id: 100, 
            name: 'f_100', 
            state: null, 
            date: DateTime.now(), 
            price: 2000000,
            pdfUrl: 'pdf_url'
          ),
          Feature(
            id: 101, 
            name: 'f_101', 
            state: null, 
            date: DateTime.now(), 
            price: 2000000,
            pdfUrl: 'pdf_url'
          )
        ],
        oldCdps: [
          Feature(
            id: 200, 
            name: 'f_200', 
            state: FeatureState.Denied, 
            date: DateTime.now(), 
            price: 2000000,
            pdfUrl: 'pdf_url'
          ),
          Feature(
            id: 201, 
            name: 'f_201', 
            state: FeatureState.Permitted, 
            date: DateTime.now(), 
            price: 2000000,
            pdfUrl: 'pdf_url'
          ),
          Feature(
            id: 200, 
            name: 'f_200', 
            state: FeatureState.Denied, 
            date: DateTime.now(), 
            price: 2000000,
            pdfUrl: 'pdf_url'
          ),
          Feature(
            id: 201, 
            name: 'f_201', 
            state: FeatureState.Permitted, 
            date: DateTime.now(), 
            price: 2000000,
            pdfUrl: 'pdf_url'
          )
        ]
      );
      when(remoteDataSource.getCdps(any))
          .thenAnswer((_) async => tCdps);
    });

    test('should call the specified methods', ()async{
      await budgetsRepository.getCdps();
      verify(userExtraInfoGetter.getAccessToken());
      verify(remoteDataSource.getCdps(tAccessToken));
    });

    test('should return the expected result', ()async{
      final result = await budgetsRepository.getCdps();
      expect(result, Right(tCdps));
    });
  });

  test('should return the expected result when there is an AppException', ()async{
    const errorMessage = 'error_message';
    const exception = ServerException(
      type: ServerExceptionType.NORMAL,
      message: errorMessage
    );
    when(remoteDataSource.getCdps(any))
        .thenThrow(exception);
    final result = await budgetsRepository.getCdps();
    expect(result, const Left(CdpsFailure(
      message: errorMessage,
      exception: exception
    )));
  });

  test('should return the expected result when there is another exception', ()async{
    final exception = Exception();
    when(remoteDataSource.getCdps(any))
        .thenThrow(exception);
    final result = await budgetsRepository.getCdps();
    expect(result, const Left(CdpsFailure(
      message: '', 
      exception: AppException('')
    )));
  });
}

void _testUpdateCdpsGroup(){
  late String tAccessToken;
  late List<Feature> tUpdatedCdps;
  setUp((){
    tAccessToken = 'access_token';
    when(userExtraInfoGetter.getAccessToken())
        .thenAnswer((_) async => tAccessToken);
    tUpdatedCdps = [
      Feature(
        id: 200, 
        name: 'f_200', 
        state: FeatureState.Denied, 
        date: DateTime.now(), 
        price: 2000000,
        pdfUrl: 'pdf_url'
      ),
      Feature(
        id: 201, 
        name: 'f_201', 
        state: FeatureState.Permitted, 
        date: DateTime.now(), 
        price: 2000000,
        pdfUrl: 'pdf_url'
      ),
      Feature(
        id: 200, 
        name: 'f_200', 
        state: FeatureState.Denied, 
        date: DateTime.now(), 
        price: 2000000,
        pdfUrl: 'pdf_url'
      ),
      Feature(
        id: 201, 
        name: 'f_201', 
        state: FeatureState.Permitted, 
        date: DateTime.now(), 
        price: 2000000,
        pdfUrl: 'pdf_url'
      )
    ];
  });

  test('should call the specified methods when all goes good', ()async{
    await budgetsRepository.updateCdps(tUpdatedCdps);
    verify(userExtraInfoGetter.getAccessToken());
    verify(remoteDataSource.updateCdps(tUpdatedCdps, tAccessToken));
  });

  test('should return the expected result when all goes good', ()async{
    final result = await budgetsRepository.updateCdps(tUpdatedCdps);
    expect(result, const Right(null));
  });

  test('should return the expected result when there is an AppException', ()async{
    const errorMessage = 'error_message';
    const exception = ServerException(
      type: ServerExceptionType.NORMAL,
      message: errorMessage
    );
    when(remoteDataSource.updateCdps(any, any))
        .thenThrow(exception);
    final result = await budgetsRepository.updateCdps(tUpdatedCdps);
    expect(result, const Left(CdpsFailure(
      message: errorMessage,
      exception: exception
    )));
  });

  test('should return the expected result when there is another exception', ()async{
    final exception = Exception();
    when(remoteDataSource.updateCdps(any, any))
        .thenThrow(exception);
    final result = await budgetsRepository.updateCdps(tUpdatedCdps);
    expect(result, const Left(CdpsFailure(
      message: '', 
      exception: AppException('')
    )));
  });
}