import 'dart:io';
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
import 'package:siex/features/cdps/presentation/use_cases/get_cdp_pdf.dart';
import 'package:siex/features/cdps/presentation/use_cases/get_cdps.dart';
import 'package:siex/features/cdps/presentation/use_cases/update_cdps.dart';

import 'cdps_bloc_test.mocks.dart';

late CdpsBloc cdpsBloc;
late MockGetCdps getCdps;
late MockUpdateCdps updateCdps;
late MockGetCdpPdf getCdpPdf;

@GenerateMocks([
  GetCdps,
  UpdateCdps,
  GetCdpPdf,
  File
])
void main(){
  setUp((){
    getCdpPdf = MockGetCdpPdf();
    updateCdps = MockUpdateCdps();
    getCdps = MockGetCdps();
    cdpsBloc = CdpsBloc(
      getCdps: getCdps,
      updateCdps: updateCdps,
      getCdpPdf: getCdpPdf
    );
  });
  
  group('change feature selection', _testChangeFeatureSelectionGroup);
  group('update cdp', _testUpdateCdpGroup);
  group('load cdps', _testLoadCdpsGroup);
  group('change cdps type', _testChangeCdpsTypeGroup);
  group('update cdps', _testUpdateCdpsGroup);
  group('load cdp pdf', _testLoadCdpPdfGroup);
  group('back to cdps', _testBackToCdpsGroup);
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
    cdpsBloc.emit(OnNewCdpsSuccess(
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
    expectLater(cdpsBloc.stream, emitsInOrder(expectedOrderedStates));
    cdpsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is selected and current state is newCdps', ()async{
    tSelectionInit = [true, true, false];
    cdpsBloc.emit(OnNewCdpsSuccess(
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
    expectLater(cdpsBloc.stream, emitsInOrder(expectedOrderedStates));
    cdpsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the second and it is selected and current state is newCdps', ()async{
    tSelectionInit = [true, true, false];
    cdpsBloc.emit(OnNewCdpsSuccess(
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
    expectLater(cdpsBloc.stream, emitsInOrder(expectedOrderedStates));
    cdpsBloc.add(ChangeFeatureSelectionEvent(index: 1));
  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is unselected and current state is oldCdps', ()async{
    tSelectionInit = [false, true, false, false];
    cdpsBloc.emit(OnOldCdpsSuccess(
      cdps: tCdps,
      featuresSelection: tSelectionInit,
      canUpdateNewCdps: true
    ));
    final expectedOrderedStates = [
      OnOldCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [true, true, false, false],
        canUpdateNewCdps: true
      )
    ];
    expectLater(cdpsBloc.stream, emitsInOrder(expectedOrderedStates));
    cdpsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is selected and current state is oldCdps', ()async{
    tSelectionInit = [true, true, false, false];
    cdpsBloc.emit(OnOldCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: tSelectionInit,
      canUpdateNewCdps: false
    ));
    final expectedOrderedStates = [
      OnOldCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [false, true, false, false],
        canUpdateNewCdps: false
      )
    ];
    expectLater(cdpsBloc.stream, emitsInOrder(expectedOrderedStates));
    cdpsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the second and it is selected and current state is oldCdps', ()async{
    tSelectionInit = [true, true, false, false];
    cdpsBloc.emit(OnOldCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: tSelectionInit,
      canUpdateNewCdps: true
    ));
    final expectedOrderedStates = [
      OnOldCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [true, false, false, false],
        canUpdateNewCdps: true
      )
    ];
    expectLater(cdpsBloc.stream, emitsInOrder(expectedOrderedStates));
    cdpsBloc.add(ChangeFeatureSelectionEvent(index: 1));
  });
}

void _testUpdateCdpGroup(){
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
    cdpsBloc.emit(OnNewCdpsSuccess(
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
    expectLater(cdpsBloc.stream, emitsInOrder(states));
    cdpsBloc.add(UpdateFeatureEvent(index: 0, newState: TimeState.permitted));
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
    cdpsBloc.emit(OnNewCdpsSuccess(
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
    expectLater(cdpsBloc.stream, emitsInOrder(states));
    cdpsBloc.add(UpdateFeatureEvent(index: 2, newState: TimeState.denied));
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
    cdpsBloc.emit(OnNewCdpsSuccess(
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
    expectLater(cdpsBloc.stream, emitsInOrder(states));
    cdpsBloc.add(UpdateFeatureEvent(index: 2, newState: TimeState.returned));
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
    cdpsBloc.add(LoadCdpsEvent());
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
    expectLater(cdpsBloc.stream, emitsInOrder(states));
    cdpsBloc.add(LoadCdpsEvent());
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
    cdpsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: const [false, true, false], 
      canUpdateNewCdps: false
    ));
    final expectedOrderedStates = [
      OnOldCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [false, false, false, false],
        canUpdateNewCdps: false
      )
    ];
    expectLater(cdpsBloc.stream, emitsInOrder(expectedOrderedStates));
    cdpsBloc.add(ChangeCdpsTypeEvent(CdpsType.oldType));
  });

  test('should emit the expected ordered states when current state is newCdps', ()async{
    cdpsBloc.emit(OnOldCdpsSuccess(
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
    expectLater(cdpsBloc.stream, emitsInOrder(expectedOrderedStates));
    cdpsBloc.add(ChangeCdpsTypeEvent(CdpsType.newType));
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
    cdpsBloc.emit(OnNewCdpsSuccess(
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
      cdpsBloc.add(UpdateCdpsEvent());
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
      expectLater(cdpsBloc.stream, emitsInOrder(states));
      cdpsBloc.add(UpdateCdpsEvent());
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
      cdpsBloc.add(UpdateCdpsEvent());
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
      expectLater(cdpsBloc.stream, emitsInOrder(states));
      cdpsBloc.add(UpdateCdpsEvent());
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
      cdpsBloc.add(UpdateCdpsEvent());
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
      expectLater(cdpsBloc.stream, emitsInOrder(states));
      cdpsBloc.add(UpdateCdpsEvent());
    });
  });
}

void _testLoadCdpPdfGroup(){
  late Cdp tSelectedCdp;
  late CdpsGroup tCdps;
  late List<bool> tFeaturesSelection;
  late bool tCanUpdateNewCdps;
  setUp((){
    tCdps = CdpsGroup(
      newCdps: [
        Cdp(
          id: 0, 
          name: 'cpd_0', 
          state: TimeState.permitted, 
          date: DateTime.now(),
          price: 2000,
          pdfUrl: 'pdf_url_0'
        ),
        Cdp(
          id: 1, 
          name: 'cpd_1',
          state: null, 
          date: DateTime.now(),
          price: 2000,
          pdfUrl: 'pdf_url_1'
        )
      ], 
      oldCdps: [
        Cdp(
          id: 2, 
          name: 'cpd_2', 
          state: TimeState.denied, 
          date: DateTime.now(),
          price: 2000,
          pdfUrl: 'pdf_url_2'
        ),
        Cdp(
          id: 3, 
          name: 'cpd_3', 
          state: TimeState.permitted, 
          date: DateTime.now(),
          price: 2000,
          pdfUrl: 'pdf_url_3'
        )
      ]
    );
  });

  group('when the current state is new', (){
    setUp((){
      tFeaturesSelection = const [false, true];
      tCanUpdateNewCdps = false;
      tSelectedCdp = tCdps.newCdps.first;
      cdpsBloc.emit(OnNewCdpsSuccess(
        cdps: tCdps,
        featuresSelection: tFeaturesSelection,
        canUpdateNewCdps: tCanUpdateNewCdps
      ));
    });

    group('when all goes good', (){
      late MockFile tPdf;
      setUp((){
        tPdf = MockFile();
        when(tPdf.path).thenReturn('pdf_path');
        when(getCdpPdf(any))
            .thenAnswer((_) async => Right(tPdf));
      });

      test('should call the specified methods', ()async{
        cdpsBloc.add(LoadCdpPdfEvent(tSelectedCdp));
        await untilCalled(getCdpPdf(any));
        verify(getCdpPdf(tSelectedCdp));
      });

      test('should emit the expected ordered states', ()async{
        final states = [
          OnLoadingCdps(),
          OnCdpPdf(
            pdf: tPdf, 
            cdps: tCdps, 
            featuresSelection: tFeaturesSelection, 
            canUpdateNewCdps: tCanUpdateNewCdps,
            cdpsType: CdpsType.newType
          )
        ];
        expectLater(cdpsBloc.stream, emitsInOrder(states));
        cdpsBloc.add(LoadCdpPdfEvent(tSelectedCdp));
      });
    });

    test('should emit the expected ordered states when usecase returns Left Failure with error message', ()async{
      const errorMessage = 'the_error_message';
      when(getCdpPdf(any))
          .thenAnswer((_) async => const Left(CdpsFailure(
            exception: ServerException(
              type: ServerExceptionType.NORMAL,
              message: errorMessage
            ),
            message: errorMessage
          )));
      final states = [
        OnLoadingCdps(),
        OnNewCdpsError(
          cdps: tCdps, 
          featuresSelection: tFeaturesSelection, 
          canUpdateNewCdps: tCanUpdateNewCdps,
          message: errorMessage
        )
      ];
      expectLater(cdpsBloc.stream, emitsInOrder(states));
      cdpsBloc.add(LoadCdpPdfEvent(tSelectedCdp));
    });
    test('should emit the expected ordered states when usecase returns Left Failure withOut error message', ()async{
      when(getCdpPdf(any))
          .thenAnswer((_) async => const Left(CdpsFailure(
            exception: ServerException(
              type: ServerExceptionType.NORMAL,
              message: ''
            ),
            message: ''
          )));
      final states = [
        OnLoadingCdps(),
        OnNewCdpsError(
          cdps: tCdps, 
          featuresSelection: tFeaturesSelection, 
          canUpdateNewCdps: tCanUpdateNewCdps,
          message: CdpsBloc.generalErrorMessage
        )
      ];
      expectLater(cdpsBloc.stream, emitsInOrder(states));
      cdpsBloc.add(LoadCdpPdfEvent(tSelectedCdp));
    });
  });

  group('when the current state is old', (){
    setUp((){
      tFeaturesSelection = const [false, true];
      tCanUpdateNewCdps = false;
      tSelectedCdp = tCdps.newCdps.first;
      cdpsBloc.emit(OnOldCdpsSuccess(
        cdps: tCdps,
        featuresSelection: tFeaturesSelection,
        canUpdateNewCdps: tCanUpdateNewCdps
      ));
    });

    group('when all goes good', (){
      late MockFile tPdf;
      setUp((){
        tPdf = MockFile();
        when(tPdf.path).thenReturn('pdf_path');
        when(getCdpPdf(any))
            .thenAnswer((_) async => Right(tPdf));
      });

      test('should call the specified methods', ()async{
        cdpsBloc.add(LoadCdpPdfEvent(tSelectedCdp));
        await untilCalled(getCdpPdf(any));
        verify(getCdpPdf(tSelectedCdp));
      });

      test('should emit the expected ordered states', ()async{
        final states = [
          OnLoadingCdps(),
          OnCdpPdf(
            pdf: tPdf, 
            cdps: tCdps, 
            featuresSelection: tFeaturesSelection, 
            canUpdateNewCdps: tCanUpdateNewCdps,
            cdpsType: CdpsType.oldType
          )
        ];
        expectLater(cdpsBloc.stream, emitsInOrder(states));
        cdpsBloc.add(LoadCdpPdfEvent(tSelectedCdp));
      });
    });

    test('should emit the expected ordered states when usecase returns Left Failure with error message', ()async{
      const errorMessage = 'the_error_message';
      when(getCdpPdf(any))
          .thenAnswer((_) async => const Left(CdpsFailure(
            exception: ServerException(
              type: ServerExceptionType.NORMAL,
              message: errorMessage
            ),
            message: errorMessage
          )));
      final states = [
        OnLoadingCdps(),
        OnOldCdpsError(
          cdps: tCdps, 
          featuresSelection: tFeaturesSelection, 
          canUpdateNewCdps: tCanUpdateNewCdps,
          message: errorMessage
        )
      ];
      expectLater(cdpsBloc.stream, emitsInOrder(states));
      cdpsBloc.add(LoadCdpPdfEvent(tSelectedCdp));
    });
    test('should emit the expected ordered states when usecase returns Left Failure withOut error message', ()async{
      when(getCdpPdf(any))
          .thenAnswer((_) async => const Left(CdpsFailure(
            exception: ServerException(
              type: ServerExceptionType.NORMAL,
              message: ''
            ),
            message: ''
          )));
      final states = [
        OnLoadingCdps(),
        OnOldCdpsError(
          cdps: tCdps, 
          featuresSelection: tFeaturesSelection, 
          canUpdateNewCdps: tCanUpdateNewCdps,
          message: CdpsBloc.generalErrorMessage
        )
      ];
      expectLater(cdpsBloc.stream, emitsInOrder(states));
      cdpsBloc.add(LoadCdpPdfEvent(tSelectedCdp));
    });
  });
}

void _testBackToCdpsGroup(){
  late MockFile tPdf;
  late CdpsGroup tCdps;
  late List<bool> tFeaturesSelection;
  late bool tCanUpdateNewCdps;
  setUp((){
    tCdps = CdpsGroup(
      newCdps: [
        Cdp(
          id: 0, 
          name: 'cpd_0', 
          state: TimeState.permitted, 
          date: DateTime.now(),
          price: 2000,
          pdfUrl: 'pdf_url_0'
        ),
        Cdp(
          id: 1, 
          name: 'cpd_1',
          state: null, 
          date: DateTime.now(),
          price: 2000,
          pdfUrl: 'pdf_url_1'
        )
      ], 
      oldCdps: [
        Cdp(
          id: 2, 
          name: 'cpd_2', 
          state: TimeState.denied, 
          date: DateTime.now(),
          price: 2000,
          pdfUrl: 'pdf_url_2'
        ),
        Cdp(
          id: 3, 
          name: 'cpd_3', 
          state: TimeState.permitted, 
          date: DateTime.now(),
          price: 2000,
          pdfUrl: 'pdf_url_3'
        )
      ]
    );
    tFeaturesSelection = const [false, true];
    tCanUpdateNewCdps = false;
    tPdf = MockFile();
    when(tPdf.path)
        .thenReturn('pdf_path');
  });
  test('should emit the expected ordered states when the cdpsType is new', ()async{
    cdpsBloc.emit(OnCdpPdf(
      pdf: tPdf, 
      cdpsType: CdpsType.newType, 
      cdps: tCdps, 
      featuresSelection: tFeaturesSelection, 
      canUpdateNewCdps: tCanUpdateNewCdps
    ));
    final states = [
      OnNewCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: tFeaturesSelection, 
        canUpdateNewCdps: tCanUpdateNewCdps
      )
    ];
    expectLater(cdpsBloc.stream, emitsInOrder(states));
    cdpsBloc.add(BackToCdpsEvent());
  });

  test('should emit the expected ordered states when the cdpsType is old', ()async{
    cdpsBloc.emit(OnCdpPdf(
      pdf: tPdf, 
      cdpsType: CdpsType.oldType, 
      cdps: tCdps, 
      featuresSelection: tFeaturesSelection, 
      canUpdateNewCdps: tCanUpdateNewCdps
    ));
    final states = [
      OnOldCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: tFeaturesSelection, 
        canUpdateNewCdps: tCanUpdateNewCdps
      )
    ];
    expectLater(cdpsBloc.stream, emitsInOrder(states));
    cdpsBloc.add(BackToCdpsEvent());
  });
}