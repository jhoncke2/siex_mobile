import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:siex/core/domain/exceptions.dart';
import 'package:siex/core/external/user_extra_info_getter.dart';
import 'package:siex/features/records/data/records_remote_data_source.dart';
import 'package:siex/features/records/data/records_repository_impl.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/domain/records_failure.dart';
import 'records_repository_impl_test.mocks.dart';

late RecordsRepositoryImpl recordsRepository;
late MockRecordsRemoteDataSource remoteDataSource;
late MockUserExtraInfoGetter userExtraInfoGetter;

@GenerateMocks([
  RecordsRemoteDataSource,
  UserExtraInfoGetter
])
void main(){
  setUp((){
    userExtraInfoGetter = MockUserExtraInfoGetter();
    remoteDataSource = MockRecordsRemoteDataSource();
    recordsRepository = RecordsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      userExtraInfoGetter: userExtraInfoGetter
    );
  });

  group('get new records', _testGetNewRecordsGroup);
  group('get old records', _testGetOldRecordsGroup);
  group('update records', _testUpdateRecordsGroup);
}

void _testGetNewRecordsGroup(){
  late String tAccessToken;
  setUp((){
    tAccessToken = 'access_token';
    when(userExtraInfoGetter.getAccessToken())
        .thenAnswer((_) async => tAccessToken);
  });
  
  group('when all goes good', (){
    late List<Record> tRecords;
    setUp((){
      tRecords = [
        Record(
          id: 0, 
          name: 'r_0', 
          state: null, 
          date: DateTime.now(), 
          price: 20000, 
          pdfUrl: 'pdf_url_0',
          cdpName: 'cdp_0'
        ),
        Record(
          id: 1, 
          name: 'r_1', 
          state: null, 
          date: DateTime.now(), 
          price: 30000, 
          pdfUrl: 'pdf_url_1',
          cdpName: 'cdp_0'
        ),
        Record(
          id: 2, 
          name: 'r_2', 
          state: null, 
          date: DateTime.now(), 
          price: 40000, 
          pdfUrl: 'pdf_url_2',
          cdpName: 'cdp_1'
        )
      ];
      when(remoteDataSource.getNewRecords(any))
          .thenAnswer((_) async => tRecords);
    });

    test('Debe llamar a los métodos especificados', ()async{
      await recordsRepository.getNewRecords();
      verify(userExtraInfoGetter.getAccessToken());
      verify(remoteDataSource.getNewRecords(tAccessToken));
    });

    test('Debe retornar el resultado esperado', ()async{
      final result = await recordsRepository.getNewRecords();
      expect(result, Right(tRecords));
    });
  });

  test('Debe retornar el resultado esperado cuando el remoteDataSource lanza un AppException', ()async{
    const errorMessage = 'error_message';
    const exception = ServerException(
      type: ServerExceptionType.NORMAL,
      message: errorMessage
    );
    when(remoteDataSource.getNewRecords(any))
        .thenThrow(exception);
    final result = await recordsRepository.getNewRecords();
    expect(result, const Left(RecordsFailure(
      message: errorMessage, 
      exception: exception
    )));
  });

  test('Debe retornar el resultado esperado cuando el remoteDataSource lanza otro tipo de Exception', ()async{
    final exception = Exception();
    when(remoteDataSource.getNewRecords(any))
        .thenThrow(exception);
    final result = await recordsRepository.getNewRecords();
    expect(result, const Left(RecordsFailure(
      message: '', 
      exception: AppException('')
    )));
  });
}

void _testGetOldRecordsGroup(){
  late String tAccessToken;
  setUp((){
    tAccessToken = 'access_token';
    when(userExtraInfoGetter.getAccessToken())
        .thenAnswer((_) async => tAccessToken);
  });
  
  group('Cuando todo sale bien', (){
    late List<Record> tRecords;
    setUp((){
      tRecords = [
        Record(
          id: 0, 
          name: 'r_0', 
          state: null, 
          date: DateTime.now(), 
          price: 20000, 
          pdfUrl: 'pdf_url_0',
          cdpName: 'cdp_0'
        ),
        Record(
          id: 1, 
          name: 'r_1', 
          state: null, 
          date: DateTime.now(), 
          price: 30000, 
          pdfUrl: 'pdf_url_1',
          cdpName: 'cdp_1'
        ),
        Record(
          id: 2, 
          name: 'r_2', 
          state: null, 
          date: DateTime.now(), 
          price: 40000, 
          pdfUrl: 'pdf_url_2',
          cdpName: 'cdp_0'
        )
      ];
      when(remoteDataSource.getOldRecords(any))
          .thenAnswer((_) async => tRecords);
    });

    test('Debe llamar a los métodos especificados', ()async{
      await recordsRepository.getOldRecords();
      verify(userExtraInfoGetter.getAccessToken());
      verify(remoteDataSource.getOldRecords(tAccessToken));
    });

    test('Debe retornar el resultado esperado', ()async{
      final result = await recordsRepository.getOldRecords();
      expect(result, Right(tRecords));
    });
  });

  test('Debe retornar el resultado esperado cuando el remoteDataSource lanza un AppException', ()async{
    const errorMessage = 'error_message';
    const exception = ServerException(
      type: ServerExceptionType.NORMAL,
      message: errorMessage
    );
    when(remoteDataSource.getOldRecords(any))
        .thenThrow(exception);
    final result = await recordsRepository.getOldRecords();
    expect(result, const Left(RecordsFailure(
      message: errorMessage, 
      exception: exception
    )));
  });

  test('Debe retornar el resultado esperado cuando el remoteDataSource lanza otro tipo de Exception', ()async{
    final exception = Exception();
    when(remoteDataSource.getOldRecords(any))
        .thenThrow(exception);
    final result = await recordsRepository.getOldRecords();
    expect(result, const Left(RecordsFailure(
      message: '', 
      exception: AppException('')
    )));
  });
}

void _testUpdateRecordsGroup(){
  late String tAccessToken;
  late List<Record> tRecords;
  setUp((){
    tAccessToken = 'access_token';
    tRecords = [
      Record(
        id: 0, 
        name: 'r_0', 
        state: null, 
        date: DateTime.now(), 
        price: 20000,
        pdfUrl: 'pdf_url_0',
        cdpName: 'cdp_2'
      ),
      Record(
        id: 1, 
        name: 'r_1', 
        state: null, 
        date: DateTime.now(), 
        price: 30000,
        pdfUrl: 'pdf_url_1',
        cdpName: 'cdp_2'
      ),
      Record(
        id: 2, 
        name: 'r_2', 
        state: null, 
        date: DateTime.now(), 
        price: 40000,
        pdfUrl: 'pdf_url_2',
        cdpName: 'cdp_2'
      )
    ];
    when(userExtraInfoGetter.getAccessToken())
        .thenAnswer((_) async => tAccessToken);
  });

  test('Debe llamar los métodos necesarios', ()async{
    await recordsRepository.updateRecords(tRecords);
    verify(userExtraInfoGetter.getAccessToken());
    verify(remoteDataSource.updateRecords(tRecords, tAccessToken));
  });

  test('Debe retornar el resultado esperado cuando todo sale bien', ()async{
    final result = await recordsRepository.updateRecords(tRecords);
    expect(result, const Right(null));
  });

  test('Debe retornar el resultado esperado cuando el remoteDataSource lanza un AppException', ()async{
    const errorMessage = 'error_message';
    const exception = ServerException(
      type: ServerExceptionType.NORMAL,
      message: errorMessage
    );
    when(remoteDataSource.updateRecords(any, any))
        .thenThrow(exception);
    final result = await recordsRepository.updateRecords(tRecords);
    expect(result, const Left(RecordsFailure(
      message: errorMessage, 
      exception: exception
    )));
  });

  test('Debe retornar el resultado esperado cuando el remoteDataSource lanza otro tipo de Exception', ()async{
    final exception = Exception();
    when(remoteDataSource.updateRecords(any, any))
        .thenThrow(exception);
    final result = await recordsRepository.updateRecords(tRecords);
    expect(result, const Left(RecordsFailure(
      message: '', 
      exception: AppException('')
    )));
  });
}