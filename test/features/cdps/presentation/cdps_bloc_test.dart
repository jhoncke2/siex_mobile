import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:siex/core/domain/entities/time_state.dart';
import 'package:siex/core/domain/exceptions.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_bloc.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_event.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_state.dart';
import 'package:siex/features/cdps/presentation/use_cases/get_cdps.dart';
import 'package:siex/features/cdps/presentation/use_cases/update_cdps.dart';
import 'cdps_bloc_test.mocks.dart';

late CdpsBloc budgetsBloc;
late MockGetCdps getCdps;
late MockUpdateCdps updateCdps;

@GenerateMocks([
  GetCdps,
  UpdateCdps
])
void main(){
  setUp((){
    updateCdps = MockUpdateCdps();
    getCdps = MockGetCdps();
    budgetsBloc = CdpsBloc(
      getCdps: getCdps,
      updateCdps: updateCdps
    );
  });
  
  group('change feature selection', _testChangeFeatureSelectionGroup);
  group('update feature', _testUpdateFeatureGroup);
  group('load cdps', _testLoadCdpsGroup);
  group('change cdps type', _testChangeCdpsTypeGroup);
  group('update cdps', _testUpdateCdpsGroup);
}


void _testChangeFeatureSelectionGroup(){
  late CdpsGroup tCdps;
  late List<bool> tSelectionInit;
  setUp((){
    tCdps = CdpsGroup(
      newCdps: [
        Cdp(
          id: 100, 
          name: 'f_100', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 101, 
          name: 'f_101', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 102, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        )
      ], 
      oldCdps: [
        Cdp(
          id: 200, 
          name: 'f_200', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 201, 
          name: 'f_201', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 202, 
          name: 'f_202', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 203, 
          name: 'f_203', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.denied,
          pdfUrl: 'pdf_url'
        )
      ]
    );
  });


  test('shold yield the expected ordered states when the selection updated feature is the first and it is unselected and current state is newCdps', ()async{
    tSelectionInit = [false, true, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: tSelectionInit, 
      canUpdateNewCdps: false
    ));
    final expectedOrderedStates = [
      OnNewCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [true, true, false], 
        canUpdateNewCdps: false
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is selected and current state is newCdps', ()async{
    tSelectionInit = [true, true, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: tSelectionInit, 
      canUpdateNewCdps: false
    ));
    final expectedOrderedStates = [
      OnNewCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [false, true, false], 
        canUpdateNewCdps: false
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the second and it is selected and current state is newCdps', ()async{
    tSelectionInit = [true, true, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: tSelectionInit, 
      canUpdateNewCdps: true
    ));
    final expectedOrderedStates = [
      OnNewCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [true, false, false], 
        canUpdateNewCdps: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 1));
  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is unselected and current state is oldCdps', ()async{
    tSelectionInit = [false, true, false, false];
    budgetsBloc.emit(OnOldCdps(
      cdps: tCdps,
      featuresSelection: tSelectionInit,
      canUpdateNewCdps: true
    ));
    final expectedOrderedStates = [
      OnOldCdps(
        cdps: tCdps, 
        featuresSelection: const [true, true, false, false],
        canUpdateNewCdps: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is selected and current state is oldCdps', ()async{
    tSelectionInit = [true, true, false, false];
    budgetsBloc.emit(OnOldCdps(
      cdps: tCdps, 
      featuresSelection: tSelectionInit,
      canUpdateNewCdps: false
    ));
    final expectedOrderedStates = [
      OnOldCdps(
        cdps: tCdps, 
        featuresSelection: const [false, true, false, false],
        canUpdateNewCdps: false
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the second and it is selected and current state is oldCdps', ()async{
    tSelectionInit = [true, true, false, false];
    budgetsBloc.emit(OnOldCdps(
      cdps: tCdps, 
      featuresSelection: tSelectionInit,
      canUpdateNewCdps: true
    ));
    final expectedOrderedStates = [
      OnOldCdps(
        cdps: tCdps, 
        featuresSelection: const [true, false, false, false],
        canUpdateNewCdps: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 1));
  });
}

void _testUpdateFeatureGroup(){
  late List<bool> tFeaturesSelection;
  late List<Cdp> tNewCdpsInit;
  late List<Cdp> tNewCdpsUpdated;
  late CdpsGroup tCdpsInit;
  late CdpsGroup tCdpsUpdated;
  test('should emit the expected ordered states when canUpdate is false and the new feature is permitted', ()async{
    tNewCdpsInit = [
      Cdp(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url'
      )
    ];
    tNewCdpsUpdated = [
      Cdp(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url'
      )
    ];
    tFeaturesSelection = [false, true, false];
    tCdpsInit = CdpsGroup(newCdps: tNewCdpsInit, oldCdps: const []);
    tCdpsUpdated = CdpsGroup(newCdps: tNewCdpsUpdated, oldCdps: const []);
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdpsInit, 
      featuresSelection: tFeaturesSelection, 
      canUpdateNewCdps: false
    ));
    final states = [
      OnNewCdpsSuccess(
        cdps: tCdpsUpdated, 
        featuresSelection: tFeaturesSelection, 
        canUpdateNewCdps: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(states));
    budgetsBloc.add(UpdateFeatureEvent(index: 0, newState: TimeState.permitted));
  });

  test('should emit the expected ordered states when canUpdate is false and the new feature is denied', ()async{
    tNewCdpsInit = [
      Cdp(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url'
      )
    ];
    tNewCdpsUpdated = [
      Cdp(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.denied,
        pdfUrl: 'pdf_url'
      )
    ];
    tCdpsInit = CdpsGroup(newCdps: tNewCdpsInit, oldCdps: const []);
    tCdpsUpdated = CdpsGroup(newCdps: tNewCdpsUpdated, oldCdps: const []);
    tFeaturesSelection = [true, false, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdpsInit, 
      featuresSelection: tFeaturesSelection, 
      canUpdateNewCdps: false
    ));
    final states = [
      OnNewCdpsSuccess(
        cdps: tCdpsUpdated, 
        featuresSelection: tFeaturesSelection, 
        canUpdateNewCdps: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(states));
    budgetsBloc.add(UpdateFeatureEvent(index: 2, newState: TimeState.denied));
  });

  test('should emit the expected ordered states when canUpdate is false and the new feature is returned', ()async{
    tNewCdpsInit = [
      Cdp(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url'
      )
    ];
    tNewCdpsUpdated = [
      Cdp(
        id: 100, 
        name: 'f_100', 
        date: DateTime.now(), 
        price: 2000000, 
        state: null,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 101, 
        name: 'f_101', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.permitted,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 102, 
        name: 'f_102', 
        date: DateTime.now(), 
        price: 2000000, 
        state: TimeState.returned,
        pdfUrl: 'pdf_url'
      )
    ];
    tCdpsInit = CdpsGroup(newCdps: tNewCdpsInit, oldCdps: const []);
    tCdpsUpdated = CdpsGroup(newCdps: tNewCdpsUpdated, oldCdps: const []);
    tFeaturesSelection = [true, false, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdpsInit, 
      featuresSelection: tFeaturesSelection, 
      canUpdateNewCdps: false
    ));
    final states = [
      OnNewCdpsSuccess(
        cdps: tCdpsUpdated, 
        featuresSelection: tFeaturesSelection, 
        canUpdateNewCdps: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(states));
    budgetsBloc.add(UpdateFeatureEvent(index: 2, newState: TimeState.returned));
  });
}

void _testLoadCdpsGroup(){
  late CdpsGroup tCdps;
  setUp((){
    tCdps = CdpsGroup(
      newCdps: [
        Cdp(
          id: 100, 
          name: 'f_100', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 101, 
          name: 'f_101', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 102, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 3000000, 
          state: null,
          pdfUrl: 'pdf_url'
        )
      ], 
      oldCdps: [
        Cdp(
          id: 200, 
          name: 'f_100', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 201, 
          name: 'f_101', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 202, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 3000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 203, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 3000000, 
          state: null,
          pdfUrl: 'pdf_url'
        )
      ]
    );
    when(getCdps())
        .thenAnswer((_) async => Right(tCdps));
  });

  test('should call the specified methods', ()async{
    budgetsBloc.add(LoadCdpsEvent());
    await untilCalled(getCdps());
    verify(getCdps());
  });

  test('should emit the expected ordered states', ()async{
    final states = [
      OnLoadingCdps(),
      OnNewCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [false, false, false],
        canUpdateNewCdps: false
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(states));
    budgetsBloc.add(LoadCdpsEvent());
  });
}

void _testChangeCdpsTypeGroup(){
  late CdpsGroup tCdps;
  setUp((){
    tCdps = CdpsGroup(
      newCdps: [
        Cdp(
          id: 100, 
          name: 'f_100', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 101, 
          name: 'f_101', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 102, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 3000000, 
          state: null,
          pdfUrl: 'pdf_url'
        )
      ], 
      oldCdps: [
        Cdp(
          id: 200, 
          name: 'f_100', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 201, 
          name: 'f_101', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 202, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 3000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 203, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 3000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        )
      ]
    );
  });

  test('should emit the expected ordered states when current state is newCdps', ()async{
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: const [false, true, false], 
      canUpdateNewCdps: false
    ));
    final expectedOrderedStates = [
      OnOldCdps(
        cdps: tCdps, 
        featuresSelection: const [false, false, false, false],
        canUpdateNewCdps: false
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeCdpsTypeEvent(CdpsType.oldType));
  });

  test('should emit the expected ordered states when current state is newCdps', ()async{
    budgetsBloc.emit(OnOldCdps(
      cdps: tCdps, 
      featuresSelection: const [false, true, false, true],
      canUpdateNewCdps: true
    ));
    final expectedOrderedStates = [
      OnNewCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [false, false, false], 
        canUpdateNewCdps: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeCdpsTypeEvent(CdpsType.newType));
  });
}

void _testUpdateCdpsGroup(){
  late List<bool> tFeaturesSelectionInit;
  late CdpsGroup tCdpsInit;
  setUp((){
    tCdpsInit = CdpsGroup(
      newCdps: [
        Cdp(
          id: 100, 
          name: 'f_100', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 101, 
          name: 'f_101', 
          date: DateTime.now(), 
          price: 2000000, 
          state: null,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 102, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 3000000, 
          state: null,
          pdfUrl: 'pdf_url'
        )
      ], 
      oldCdps: [
        Cdp(
          id: 200, 
          name: 'f_100', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 201, 
          name: 'f_101', 
          date: DateTime.now(), 
          price: 2000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 202, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 3000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 203, 
          name: 'f_102', 
          date: DateTime.now(), 
          price: 3000000, 
          state: TimeState.permitted,
          pdfUrl: 'pdf_url'
        )
      ]
    );
    tFeaturesSelectionInit = const [false, true, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdpsInit,
      featuresSelection: tFeaturesSelectionInit,
      canUpdateNewCdps: true
    ));
  });

  group('when all goes good', (){
    late CdpsGroup tCdpsUpdated;
    setUp((){
      tCdpsUpdated = CdpsGroup(
        newCdps: [
          Cdp(
            id: 101, 
            name: 'f_101', 
            date: DateTime.now(), 
            price: 2000000, 
            state: null,
            pdfUrl: 'pdf_url'
          ),
          Cdp(
            id: 102, 
            name: 'f_102', 
            date: DateTime.now(), 
            price: 3000000, 
            state: null,
            pdfUrl: 'pdf_url'
          )
        ], 
        oldCdps: [
          Cdp(
            id: 100, 
            name: 'f_100', 
            date: DateTime.now(), 
            price: 2000000, 
            state: TimeState.permitted,
            pdfUrl: 'pdf_url'
          ),
          Cdp(
            id: 200, 
            name: 'f_100', 
            date: DateTime.now(), 
            price: 2000000, 
            state: TimeState.permitted,
            pdfUrl: 'pdf_url'
          ),
          Cdp(
            id: 201, 
            name: 'f_101', 
            date: DateTime.now(), 
            price: 2000000, 
            state: TimeState.permitted,
            pdfUrl: 'pdf_url'
          ),
          Cdp(
            id: 202, 
            name: 'f_102', 
            date: DateTime.now(), 
            price: 3000000, 
            state: TimeState.permitted,
            pdfUrl: 'pdf_url'
          ),
          Cdp(
            id: 203, 
            name: 'f_102', 
            date: DateTime.now(), 
            price: 3000000, 
            state: TimeState.permitted,
            pdfUrl: 'pdf_url'
          )
        ]
      );
      when(updateCdps(any))
          .thenAnswer((_) async => const Right(null));
      when(getCdps())
          .thenAnswer((_) async => Right(tCdpsUpdated));
    });

    test('should call the specified methods', ()async{
      budgetsBloc.add(UpdateCdpsEvent());
      await untilCalled(updateCdps(any));
      verify(updateCdps(tCdpsInit.newCdps));
      await untilCalled(getCdps());
      verify(getCdps());
    });

    test('should emit the expected ordered states', ()async{
      final states = [
        OnLoadingCdps(),
        OnNewCdpsSuccess(
          cdps: tCdpsUpdated, 
          featuresSelection: const [false, false], 
          canUpdateNewCdps: false
        )
      ];
      expectLater(budgetsBloc.stream, emitsInOrder(states));
      budgetsBloc.add(UpdateCdpsEvent());
    });
  });

  group('when updateCdps returns Left with error message', (){
    late String tErrorMessage;
    setUp((){
      tErrorMessage = 'the error message';
      when(updateCdps(any))
          .thenAnswer((_) async => Left(CdpsFailure(
            message: tErrorMessage, 
            exception: const ServerException(
              type: ServerExceptionType.NORMAL
            )
          )));
    });

    test('should call the specified methods', ()async{
      budgetsBloc.add(UpdateCdpsEvent());
      await untilCalled(updateCdps(any));
      verify(updateCdps(tCdpsInit.newCdps));
      verifyNever(getCdps());
    });

    test('should emit the expected ordered states', ()async{
      final states = [
        OnLoadingCdps(),
        OnNewCdpsError(
          cdps: tCdpsInit, 
          featuresSelection: tFeaturesSelectionInit, 
          canUpdateNewCdps: true,
          message: tErrorMessage
        )
      ];
      expectLater(budgetsBloc.stream, emitsInOrder(states));
      budgetsBloc.add(UpdateCdpsEvent());
    });
  });

  group('when updateCdps returns Left withOut error message', (){
    setUp((){
      when(updateCdps(any))
          .thenAnswer((_) async => const Left(CdpsFailure(
            message: '', 
            exception: ServerException(
              type: ServerExceptionType.NORMAL
            )
          )));
    });

    test('should call the specified methods', ()async{
      budgetsBloc.add(UpdateCdpsEvent());
      await untilCalled(updateCdps(any));
      verify(updateCdps(tCdpsInit.newCdps));
      verifyNever(getCdps());
    });

    test('should emit the expected ordered states', ()async{
      final states = [
        OnLoadingCdps(),
        OnNewCdpsError(
          cdps: tCdpsInit, 
          featuresSelection: tFeaturesSelectionInit, 
          canUpdateNewCdps: true,
          message: CdpsBloc.generalErrorMessage
        )
      ];
      expectLater(budgetsBloc.stream, emitsInOrder(states));
      budgetsBloc.add(UpdateCdpsEvent());
    });
  });
}