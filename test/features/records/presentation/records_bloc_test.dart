import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:siex/core/domain/entities/time_state.dart';
import 'package:siex/core/domain/exceptions.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/domain/records_failure.dart';
import 'package:siex/features/records/presentation/bloc/records_bloc.dart';
import 'package:siex/features/records/presentation/use_cases/get_new_records.dart';
import 'package:siex/features/records/presentation/use_cases/get_old_records.dart';
import 'package:siex/features/records/presentation/use_cases/update_records.dart';
import 'records_bloc_test.mocks.dart';

late RecordsBloc recordsBloc;
late MockGetNewRecords getNewRecords;
late MockGetOldRecords getOldRecords;
late MockUpdateRecords updateRecords;

@GenerateMocks([
  GetNewRecords,
  GetOldRecords,
  UpdateRecords
])
void main(){
  setUp((){
    updateRecords = MockUpdateRecords();
    getOldRecords = MockGetOldRecords();
    getNewRecords = MockGetNewRecords();
    recordsBloc = RecordsBloc(
      getNewRecords: getNewRecords, 
      getOldRecords: getOldRecords, 
      updateRecords: updateRecords
    );
  });

  group('load new records', _testLoadNewRecordsGroup);
  group('update record state', _testUpdateRecordStateGroup);
  group('change records selection', _testChangeRecordsSelectionGroup);
  group('load old records', _testLoadOldRecordsGroup);
  group('update new records', _testUpdateNewRecordsGroup);
}

void _testLoadNewRecordsGroup(){
  late List<Record> tRecords;
  late List<bool> tSelectionInit;

  group('cuando todo sale bien', (){
    setUp((){
      tRecords = [
        Record(
          id: 100, 
          name: 'f_100', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url',
          cdpName: 'cdp_0'
        ),
        Record(
          id: 101, 
          name: 'f_101', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url',
          cdpName: 'cdp_0'
        ),
        Record(
          id: 102, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url',
          cdpName: 'cdp_0'
        )
      ];
      tSelectionInit = [
        false,
        false,
        false
      ];
      when(getNewRecords())
          .thenAnswer((_) async => Right(tRecords));
    });

    test('Debe llamar los métodos esperados', ()async{
      recordsBloc.add(LoadNewRecordsEvent());
      await untilCalled(getNewRecords());
      verify(getNewRecords());
    });

    test('Debe emitir los estados en el orden esperado', ()async{
      final states = [
        const OnLoadingRecords(),
        OnNewRecordsSuccess(
          records: tRecords,
          recordsSelection: tSelectionInit,
          canUpdateRecords: false
        )
      ];
      expectLater(recordsBloc.stream, emitsInOrder(states));
      recordsBloc.add(LoadNewRecordsEvent());
    });
  });

  test('Debe emitir los estados esperados cuando llega un Left Failure con mensaje', ()async{
    const errorMessage = 'error_message';
    when(getNewRecords())
        .thenAnswer((_) async => const Left(RecordsFailure(
          exception: ServerException(
            type: ServerExceptionType.NORMAL,
            message: errorMessage
          ),
          message: errorMessage
        )));
    const states = [
      OnLoadingRecords(),
      OnLoadingRecordsError(
        message: errorMessage
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(states));
    recordsBloc.add(LoadNewRecordsEvent());
  });

  test('Debe emitir los estados esperados cuando llega un Left Failure sin mensaje', ()async{
    when(getNewRecords())
        .thenAnswer((_) async => const Left(RecordsFailure(
          exception: AppException(''),
          message: ''
        )));
    const states = [
      OnLoadingRecords(),
      OnLoadingRecordsError(
        message: RecordsBloc.generalErrorMessage
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(states));
    recordsBloc.add(LoadNewRecordsEvent());
  });
}

void _testUpdateRecordStateGroup(){
  late List<bool> tRecordsSelection;
  late List<Record> tRecordsInit;
  late List<Record> tRecordsUpdated;
  test('should emit the expected ordered states when canUpdate is false and the new feature is permitted', ()async{
    tRecordsInit = [
      Record(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      )
    ];
    tRecordsUpdated = [
      Record(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      )
    ];
    tRecordsSelection = [false, true, false];
    recordsBloc.emit(OnNewRecordsSuccess(
      records: tRecordsInit, 
      recordsSelection: tRecordsSelection, 
      canUpdateRecords: false
    ));
    final states = [
      OnNewRecordsSuccess(
        records: tRecordsUpdated, 
        recordsSelection: tRecordsSelection, 
        canUpdateRecords: true
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(states));
    recordsBloc.add(const UpdateRecordStateEvent(
      index: 0, 
      newState: TimeState.permitted
    ));
  });

  test('should emit the expected ordered states when canUpdate is false and the new feature is denied', ()async{
    tRecordsInit = [
      Record(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      )
    ];
    tRecordsUpdated = [
      Record(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.denied,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      )
    ];
    tRecordsSelection = [true, false, false];
    recordsBloc.emit(OnNewRecordsSuccess(
      records: tRecordsInit, 
      recordsSelection: tRecordsSelection, 
      canUpdateRecords: false
    ));
    final states = [
      OnNewRecordsSuccess(
        records: tRecordsUpdated, 
        recordsSelection: tRecordsSelection, 
        canUpdateRecords: true
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(states));
    recordsBloc.add(const UpdateRecordStateEvent(
      index: 2, 
      newState: TimeState.denied
    ));
  });

  test('should emit the expected ordered states when canUpdate is false and the new feature is returned', ()async{
    tRecordsInit = [
      Record(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      )
    ];
    tRecordsUpdated = [
      Record(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      ),
      Record(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.returned,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_name'
      )
    ];
    tRecordsSelection = [true, false, false];
    recordsBloc.emit(OnNewRecordsSuccess(
      records: tRecordsInit, 
      recordsSelection: tRecordsSelection, 
      canUpdateRecords: false
    ));
    final states = [
      OnNewRecordsSuccess(
        records: tRecordsUpdated, 
        recordsSelection: tRecordsSelection, 
        canUpdateRecords: true
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(states));
    recordsBloc.add(UpdateRecordStateEvent(index: 2, newState: TimeState.returned));
  });
}

void _testChangeRecordsSelectionGroup(){
  late List<Record> tRecords;
  late List<bool> tSelectionInit;
  setUp((){
    tRecords = [
      Record(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_0'
      ),
      Record(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_0'
      ),
      Record(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_0'
      )
    ];
  });


  test('Debe emitir los estados en el orden esperados cuando el actual record seleccionado es el primero, habiendo estado des-seleccionado y el estado actual es OnNewRecords', ()async{
    tSelectionInit = [false, true, false];
    recordsBloc.emit(OnNewRecordsSuccess(
      records: tRecords, 
      recordsSelection: tSelectionInit, 
      canUpdateRecords: false
    ));
    final expectedOrderedStates = [
      OnNewRecordsSuccess(
        records: tRecords, 
        recordsSelection: const [true, true, false], 
        canUpdateRecords: false
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(expectedOrderedStates));
    recordsBloc.add(const ChangeRecordsSelectionEvent(index: 0));
  });

  test('Debe emitir los estados en el orden esperados cuando el actual record seleccionado es el primero, habiendo estado seleccionado y el estado actual es OnNewRecords', ()async{
    tSelectionInit = [true, true, false];
    recordsBloc.emit(OnNewRecordsSuccess(
      records: tRecords, 
      recordsSelection: tSelectionInit, 
      canUpdateRecords: false
    ));
    final expectedOrderedStates = [
      OnNewRecordsSuccess(
        records: tRecords, 
        recordsSelection: const [false, true, false], 
        canUpdateRecords: false
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(expectedOrderedStates));
    recordsBloc.add(const ChangeRecordsSelectionEvent(index: 0));
  });

  test('Debe emitir los estados en el orden esperados cuando el actual record seleccionado es el segundo, habiendo estado seleccionado y el estado actual es OnNewRecords', ()async{
    tSelectionInit = [true, true, false];
    recordsBloc.emit(OnNewRecordsSuccess(
      records: tRecords, 
      recordsSelection: tSelectionInit, 
      canUpdateRecords: true
    ));
    final expectedOrderedStates = [
      OnNewRecordsSuccess(
        records: tRecords, 
        recordsSelection: const [true, false, false], 
        canUpdateRecords: true
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(expectedOrderedStates));
    recordsBloc.add(const ChangeRecordsSelectionEvent(index: 1));
  });

  test('Debe emitir los estados en el orden esperados cuando el actual record seleccionado es el primero, habiendo estado des-seleccionado y el estado actual es OnOldRecords', ()async{
    tSelectionInit = [false, true, false, false];
    recordsBloc.emit(OnOldRecordsSuccess(
      records: tRecords,
      recordsSelection: tSelectionInit
    ));
    final expectedOrderedStates = [
      OnOldRecordsSuccess(
        records: tRecords, 
        recordsSelection: const [true, true, false, false]
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(expectedOrderedStates));
    recordsBloc.add(const ChangeRecordsSelectionEvent(index: 0));
  });

  test('Debe emitir los estados en el orden esperados cuando el actual record seleccionado es el primero, habiendo estado seleccionado y el estado actual es OnOldRecords', ()async{
    tSelectionInit = [true, true, false, false];
    recordsBloc.emit(OnOldRecordsSuccess(
      records: tRecords, 
      recordsSelection: tSelectionInit
    ));
    final expectedOrderedStates = [
      OnOldRecordsSuccess(
        records: tRecords, 
        recordsSelection: const [false, true, false, false]
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(expectedOrderedStates));
    recordsBloc.add(const ChangeRecordsSelectionEvent(index: 0));
  });

  test('Debe emitir los estados en el orden esperados cuando el actual record seleccionado es el segundo, habiendo estado seleccionado y el estado actual es OnOldRecords', ()async{
    tSelectionInit = [true, true, false, false];
    recordsBloc.emit(OnOldRecordsSuccess(
      records: tRecords, 
      recordsSelection: tSelectionInit
    ));
    final expectedOrderedStates = [
      OnOldRecordsSuccess(
        records: tRecords, 
        recordsSelection: const [true, false, false, false]
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(expectedOrderedStates));
    recordsBloc.add(const ChangeRecordsSelectionEvent(index: 1));
  });
}

void _testLoadOldRecordsGroup(){
  late List<Record> tNewRecords;
  late List<bool> tSelectionInit;
  setUp((){
    tNewRecords = [
      Record(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_1'
      ),
      Record(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_1'
      ),
      Record(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_1'
      )
    ];
    tSelectionInit = [
      false,
      false,
      false
    ];
  });

  group('Cuando todo sale bien', (){
    setUp((){
      late List<Record> tOldRecords;
      late List<bool> tSelectionNew;
      setUp((){
        recordsBloc.emit(OnNewRecordsSuccess(
          records: tNewRecords,
          recordsSelection: tSelectionInit,
          canUpdateRecords: true
        ));
        tOldRecords = [
          Record(
            id: 1000, 
            name: 'f_1000', 
            date: DateTime.now(), 
            price: 2000000, 
            state: null,
            pdfUrl: 'pdf_url',
            cdpName: 'cdp_1'
          ),
          Record(
            id: 1001, 
            name: 'f_1001', 
            date: DateTime.now(), 
            price: 2000000, 
            state: TimeState.permitted,
            pdfUrl: 'pdf_url',
            cdpName: 'cdp_1'
          )
        ];
        tSelectionNew = [false, false];
        when(getOldRecords())
            .thenAnswer((_) async => Right(tOldRecords));
      });
      test('Debe llamar a los métodos esperados', ()async{
        recordsBloc.add(LoadOldRecordsEvent());
        await untilCalled(getOldRecords());
        verify(getOldRecords());
      });

      test('Debe emitir los estados en el orden esperado', ()async{
        recordsBloc.add(LoadOldRecordsEvent());
        final states = [
          const OnLoadingRecords(),
          OnOldRecordsSuccess(
            records: tOldRecords,
            recordsSelection: tSelectionNew
          )
        ];
        expectLater(recordsBloc.stream, emitsInOrder(states));
        recordsBloc.add(LoadOldRecordsEvent());
      });
    });
  });

  group('cuando newRecords pueden ser actualizados', (){
    setUp((){
      recordsBloc.emit(OnNewRecordsSuccess(
        records: tNewRecords,
        recordsSelection: tSelectionInit,
        canUpdateRecords: true
      ));
    });
    
    test('Debe emitir los estados esperados cuando llega un Left Failure con mensaje con newRecords que pueden ser actualizados', ()async{
      const errorMessage = 'error_message';
      when(getOldRecords())
          .thenAnswer((_) async => const Left(RecordsFailure(
            exception: ServerException(
              type: ServerExceptionType.NORMAL,
              message: errorMessage
            ),
            message: errorMessage
          )));
      final states = [
        const OnLoadingRecords(),
        OnNewRecordsError(
          records: tNewRecords,
          recordsSelection: tSelectionInit,
          canUpdateRecords: true,
          message: errorMessage
        )
      ];
      expectLater(recordsBloc.stream, emitsInOrder(states));
      recordsBloc.add(LoadOldRecordsEvent());
    });

    test('Debe emitir los estados esperados cuando llega un Left Failure sin mensaje', ()async{
      when(getOldRecords())
          .thenAnswer((_) async => const Left(RecordsFailure(
            exception: AppException(''),
            message: ''
          )));
      final states = [
        const OnLoadingRecords(),
        OnNewRecordsError(
          records: tNewRecords,
          recordsSelection: tSelectionInit,
          canUpdateRecords: true,
          message: RecordsBloc.generalErrorMessage
        )
      ];
      expectLater(recordsBloc.stream, emitsInOrder(states));
      recordsBloc.add(LoadOldRecordsEvent());
    });
  });

  group('cuando newRecords No pueden ser actualizados', (){
    setUp((){
      recordsBloc.emit(OnNewRecordsSuccess(
        records: tNewRecords,
        recordsSelection: tSelectionInit,
        canUpdateRecords: false
      ));
    });
    
    test('Debe emitir los estados esperados cuando llega un Left Failure con mensaje con newRecords que pueden ser actualizados', ()async{
      const errorMessage = 'error_message';
      when(getOldRecords())
          .thenAnswer((_) async => const Left(RecordsFailure(
            exception: ServerException(
              type: ServerExceptionType.NORMAL,
              message: errorMessage
            ),
            message: errorMessage
          )));
      final states = [
        const OnLoadingRecords(),
        OnNewRecordsError(
          records: tNewRecords,
          recordsSelection: tSelectionInit,
          canUpdateRecords: false,
          message: errorMessage
        )
      ];
      expectLater(recordsBloc.stream, emitsInOrder(states));
      recordsBloc.add(LoadOldRecordsEvent());
    });

    test('Debe emitir los estados esperados cuando llega un Left Failure sin mensaje', ()async{
      when(getOldRecords())
          .thenAnswer((_) async => const Left(RecordsFailure(
            exception: AppException(''),
            message: ''
          )));
      final states = [
        const OnLoadingRecords(),
        OnNewRecordsError(
          records: tNewRecords,
          recordsSelection: tSelectionInit,
          canUpdateRecords: false,
          message: RecordsBloc.generalErrorMessage
        )
      ];
      expectLater(recordsBloc.stream, emitsInOrder(states));
      recordsBloc.add(LoadOldRecordsEvent());
    });
  });
}

void _testUpdateNewRecordsGroup(){
  late List<Record> tNewRecordsInit;
  late List<bool> tSelectionInit;
  setUp((){
    tNewRecordsInit = [
      Record(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_2'
      ),
      Record(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_2'
      ),
      Record(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url',
        cdpName: 'cdp_2'
      )
    ];
    tSelectionInit = [
      false,
      false,
      false
    ];
    recordsBloc.emit(OnNewRecordsSuccess(
      records: tNewRecordsInit, 
      recordsSelection: tSelectionInit,
      canUpdateRecords: true
    ));
  });

  group('Cuando todo sale bien', (){
    late List<Record> tNewRecordsUpdated;
    late List<bool> tSelectionUpdated;
    setUp((){
      tNewRecordsUpdated = [
        Record(
          id: 100, 
          name: 'f_100', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url',
          cdpName: 'cdp_2'
        ),
        Record(
          id: 102, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url',
          cdpName: 'cdp_2'
        )
      ];
      tSelectionUpdated = [false, false];
      when(updateRecords(any))
          .thenAnswer((_) async => const Right(null));
      when(getNewRecords())
          .thenAnswer((_) async => Right(tNewRecordsUpdated));
    });

    test('Debe llamar a los métodos esperados', ()async{
      recordsBloc.add(UpdateNewRecordsEvent());
      await untilCalled(updateRecords(any));
      verify(updateRecords(tNewRecordsInit));
    });

    test('Debe emitir los estados en el orden esperado', ()async{
      final states = [
        const OnLoadingRecords(),
        OnNewRecordsSuccess(
          records: tNewRecordsUpdated, 
          recordsSelection: tSelectionUpdated, 
          canUpdateRecords: false
        )
      ];
      expectLater(recordsBloc.stream, emitsInOrder(states));
      recordsBloc.add(UpdateNewRecordsEvent());
    });
  });

  test('Debe emitir los estados esperados cuando getNewRecords retorna un Left Failure con mensaje con newRecords que pueden ser actualizados', ()async{
    when(updateRecords(any))
        .thenAnswer((_) async => const Right(null));
    const errorMessage = 'error_message';
    when(getNewRecords())
        .thenAnswer((_) async => const Left(RecordsFailure(
          exception: ServerException(
            type: ServerExceptionType.NORMAL,
            message: errorMessage
          ),
          message: errorMessage
        )));
    final states = [
      const OnLoadingRecords(),
      OnNewRecordsError(
        records: tNewRecordsInit,
        recordsSelection: tSelectionInit,
        canUpdateRecords: true,
        message: errorMessage
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(states));
    recordsBloc.add(UpdateNewRecordsEvent());
  });

  test('Debe emitir los estados esperados cuando getNewRecords retorna un un Left Failure sin mensaje', ()async{
    when(updateRecords(any))
        .thenAnswer((_) async => const Right(null));
    when(getNewRecords())
        .thenAnswer((_) async => const Left(RecordsFailure(
          exception: AppException(''),
          message: ''
        )));
    final states = [
      const OnLoadingRecords(),
      OnNewRecordsError(
        records: tNewRecordsInit,
        recordsSelection: tSelectionInit,
        canUpdateRecords: true,
        message: RecordsBloc.generalErrorMessage
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(states));
    recordsBloc.add(UpdateNewRecordsEvent());
  });

  test('Debe emitir los estados esperados cuando updateRecords retorna un Left Failure con mensaje con newRecords que pueden ser actualizados', ()async{
    const errorMessage = 'error_message';
    when(updateRecords(any))
        .thenAnswer((_) async => const Left(RecordsFailure(
          exception: ServerException(
            type: ServerExceptionType.NORMAL,
            message: errorMessage
          ),
          message: errorMessage
        )));
    final states = [
      const OnLoadingRecords(),
      OnNewRecordsError(
        records: tNewRecordsInit,
        recordsSelection: tSelectionInit,
        canUpdateRecords: true,
        message: errorMessage
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(states));
    recordsBloc.add(UpdateNewRecordsEvent());
  });

  test('Debe emitir los estados esperados cuando updateRecords retorna un un Left Failure sin mensaje', ()async{
    when(updateRecords(any))
        .thenAnswer((_) async => const Left(RecordsFailure(
          exception: AppException(''),
          message: ''
        )));
    final states = [
      const OnLoadingRecords(),
      OnNewRecordsError(
        records: tNewRecordsInit,
        recordsSelection: tSelectionInit,
        canUpdateRecords: true,
        message: RecordsBloc.generalErrorMessage
      )
    ];
    expectLater(recordsBloc.stream, emitsInOrder(states));
    recordsBloc.add(UpdateNewRecordsEvent());
  });
}