import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:siex/core/domain/exceptions.dart';
import 'package:siex/features/budgets/domain/budgets_failures.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_bloc.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_event.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_state.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_budgets.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_cdps.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_budget.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_cdps.dart';
import 'budgets_bloc_test.mocks.dart';

late BudgetsBloc budgetsBloc;
late MockGetBudgets getBudgets;
late MockUpdateBudget updateBudget;
late MockGetCdps getCdps;
late MockUpdateCdps updateCdps;

@GenerateMocks([
  GetBudgets,
  UpdateBudget,
  GetCdps,
  UpdateCdps
])
void main(){
  setUp((){
    updateCdps = MockUpdateCdps();
    getCdps = MockGetCdps();
    updateBudget = MockUpdateBudget();
    getBudgets = MockGetBudgets();
    budgetsBloc = BudgetsBloc(
      getBudgets: getBudgets, 
      updateBudget: updateBudget,
      getCdps: getCdps,
      updateCdps: updateCdps
    );
  });
  
  group('load budgets', _testLoadBudgetsGroup);
  group('select budget', _testSelectBudgetGroup);
  group('change feature selection', _testChangeFeatureSelectionGroup);
  group('update feature', _testUpdateFeatureGroup);
  group('end budget updating', _testEndBudgetUpdatingGroup);
  group('load cdps', _testLoadCdpsGroup);
  group('update cdps', _testUpdateCdpsGroup);
}

void _testLoadBudgetsGroup(){
  late List<Budget> tBudgets;
  setUp((){
    tBudgets = [
      Budget(
        id: 0, 
        name: 'budget_0',
        completed: false,
        features: [
          Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Denied),
          Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted)
        ]
      ),
      Budget(
        id: 1,
        name: 'budget_1',
        completed: false,
        features: [
          Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Denied),
          Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted)
        ]
      )
    ];
    when(getBudgets()).thenAnswer((_) async => Right(tBudgets));
  });

  test('shold call the specified methods', ()async{
    budgetsBloc.add(LoadBudgetsEvent());
    await untilCalled(getBudgets());
    verify(getBudgets());
  });
  
  test('shold emit the expected ordered states', ()async{
    final expectedOrderedStates = [
      OnLoadingBudgets(),
      OnBudgetsLoaded(budgets: tBudgets)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(LoadBudgetsEvent());
  });
}

void _testSelectBudgetGroup(){
  late List<Budget> tBudgets;
  late List<bool> tFeaturesSelection;
  late Budget tSelectedOne;
  setUp((){
    tSelectedOne = Budget(
      id: 1, 
      name: 'budget_1',
      completed: true,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Denied),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted)
      ]
    );
    tFeaturesSelection = [false, false];
    tBudgets = [
      Budget(
        id: 0, 
        name: 'budget_0',
        completed: true,
        features: [
          Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Denied),
          Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted)
        ]
      ),
      tSelectedOne
    ];
    budgetsBloc.emit(OnBudgetsLoaded(budgets: tBudgets));
  });
  
  test('shold emit the expected ordered states when features are not all completed', ()async{
    tSelectedOne.features.first.state = null;
    final expectedOrderedStates = [
      OnBudgetUpdating(budget: tSelectedOne, featuresSelection: tFeaturesSelection, canEnd: false)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(SelectBudgetEvent(tSelectedOne));
  });

  test('shold emit the expected ordered states when features are indeed all completed', ()async{
    final expectedOrderedStates = [
      OnBudgetUpdating(budget: tSelectedOne, featuresSelection: tFeaturesSelection, canEnd: true)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(SelectBudgetEvent(tSelectedOne));
  });
}

void _testChangeFeatureSelectionGroup(){
  late List<Feature> tCdps;
  late List<bool> tSelectionInit;
  setUp((){
    tCdps = [
      Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
      Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
      Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
    ];
  });

  group('when current cdps are new', (){

  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is unselected', ()async{
    tSelectionInit = [false, true, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: tSelectionInit, 
      canUpdate: false
    ));
    final expectedOrderedStates = [
      OnNewCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [true, true, false], 
        canUpdate: false
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is selected', ()async{
    tSelectionInit = [true, true, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: tSelectionInit, 
      canUpdate: false
    ));
    final expectedOrderedStates = [
      OnNewCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [false, true, false], 
        canUpdate: false
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the second and it is selected', ()async{
    tSelectionInit = [true, true, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdps, 
      featuresSelection: tSelectionInit, 
      canUpdate: true
    ));
    final expectedOrderedStates = [
      OnNewCdpsSuccess(
        cdps: tCdps, 
        featuresSelection: const [true, false, false], 
        canUpdate: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 1));
  });
}

void _testUpdateFeatureGroup(){
  late List<bool> tFeaturesSelection;
  late List<Feature> tNewCdpsInit;
  late List<Feature> tNewCdpsUpdated;
  late CdpsGroup tCdpsInit;
  late CdpsGroup tCdpsUpdated;
  test('should emit the expected ordered states when canUpdate is false and the new feature is permitted', ()async{
    tNewCdpsInit = [
      Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
      Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
      Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
    ];
    tNewCdpsUpdated = [
      Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
      Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
      Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
    ];
    tFeaturesSelection = [false, true, false];
    tCdpsInit = CdpsGroup(newCdps: tNewCdpsInit, oldCdps: const []);
    tCdpsUpdated = CdpsGroup(newCdps: tNewCdpsUpdated, oldCdps: const []);
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdpsInit, 
      featuresSelection: tFeaturesSelection, 
      canUpdate: false
    ));
    final states = [
      OnNewCdpsSuccess(
        cdps: tCdpsUpdated, 
        featuresSelection: tFeaturesSelection, 
        canUpdate: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(states));
    budgetsBloc.add(UpdateFeatureEvent(index: 0, newState: FeatureState.Permitted));
  });

  test('should emit the expected ordered states when canUpdate is false and the new feature is denied', ()async{
    tNewCdpsInit = [
      Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
      Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
      Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
    ];
    tNewCdpsUpdated = [
      Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
      Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
      Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: FeatureState.Denied)
    ];
    tCdpsInit = CdpsGroup(newCdps: tNewCdpsInit, oldCdps: const []);
    tCdpsUpdated = CdpsGroup(newCdps: tNewCdpsUpdated, oldCdps: const []);
    tFeaturesSelection = [true, false, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdpsInit, 
      featuresSelection: tFeaturesSelection, 
      canUpdate: false
    ));
    final states = [
      OnNewCdpsSuccess(
        cdps: tCdpsUpdated, 
        featuresSelection: tFeaturesSelection, 
        canUpdate: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(states));
    budgetsBloc.add(UpdateFeatureEvent(index: 2, newState: FeatureState.Denied));
  });

  test('should emit the expected ordered states when canUpdate is false and the new feature is returned', ()async{
    tNewCdpsInit = [
      Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
      Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
      Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
    ];
    tNewCdpsUpdated = [
      Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
      Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
      Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: FeatureState.Returned)
    ];
    tCdpsInit = CdpsGroup(newCdps: tNewCdpsInit, oldCdps: const []);
    tCdpsUpdated = CdpsGroup(newCdps: tNewCdpsUpdated, oldCdps: const []);
    tFeaturesSelection = [true, false, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdpsInit, 
      featuresSelection: tFeaturesSelection, 
      canUpdate: false
    ));
    final states = [
      OnNewCdpsSuccess(
        cdps: tCdpsUpdated, 
        featuresSelection: tFeaturesSelection, 
        canUpdate: true
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(states));
    budgetsBloc.add(UpdateFeatureEvent(index: 2, newState: FeatureState.Returned));
  });
}

void _testEndBudgetUpdatingGroup(){
  late List<Budget> tNewBudgets;
  late Budget tUpdatedBudget;
  setUp((){
    tUpdatedBudget = Budget(
      id: 1, 
      name: 'budget_1',
      completed: true,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Denied),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted)
      ]
    );
    tNewBudgets = [
      Budget(
        id: 0, 
        name: 'budget_0',
        completed: true,
        features: [
          Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Denied),
          Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted)
        ]
      ),
      tUpdatedBudget
    ];
    budgetsBloc.emit(OnBudgetUpdating(budget: tUpdatedBudget, featuresSelection: const [false, true, true], canEnd: true));
    when(updateBudget(any)).thenAnswer((_) async => const Right(null));
    when(getBudgets()).thenAnswer((_) async => Right(tNewBudgets));
  });

  test('should call the specified methods', ()async{
    budgetsBloc.add(EndBudgetUpdating());
    await untilCalled(updateBudget(any));
    verify(updateBudget(tUpdatedBudget));
    await untilCalled(getBudgets());
    verify(getBudgets());
  });

  test('shold emit the expected ordered states', ()async{
    final expectedOrderedStates = [
      OnLoadingBudgets(),
      OnBudgetsLoaded(budgets: tNewBudgets)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(EndBudgetUpdating());
  });
}

void _testLoadCdpsGroup(){
  late List<Feature> tCdps;
  setUp((){
    tCdps = [
      Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
      Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: null),
      Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 3000000, state: null)
    ];
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
      OnLoadingBudgets(),
      OnNewCdpsSuccess(
        cdps: tCdps, 
        canUpdate: false,
        featuresSelection: const [false, false, false]
      )
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(states));
    budgetsBloc.add(LoadCdpsEvent());
  });
}

void _testUpdateCdpsGroup(){
  late List<Feature> tCdpsInit;
  late List<bool> tFeaturesSelectionInit;
  setUp((){
    tCdpsInit = [
      Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
      Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: null),
      Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 3000000, state: null)
    ];
    tFeaturesSelectionInit = const [false, true, false];
    budgetsBloc.emit(OnNewCdpsSuccess(
      cdps: tCdpsInit,
      featuresSelection: tFeaturesSelectionInit,
      canUpdate: true
    ));
  });

  group('when all goes good', (){
    late List<Feature> tCdpsUpdated;
    setUp((){
      tCdpsUpdated = [
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: null),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 3000000, state: null)
      ];
      when(updateCdps(any))
          .thenAnswer((_) async => const Right(null));
      when(getCdps())
          .thenAnswer((_) async => Right(tCdpsUpdated));
    });

    test('should call the specified methods', ()async{
      budgetsBloc.add(UpdateCdpsEvent());
      await untilCalled(updateCdps(any));
      verify(updateCdps(tCdpsInit));
      await untilCalled(getCdps());
      verify(getCdps());
    });

    test('should emit the expected ordered states', ()async{
      final states = [
        OnLoadingBudgets(),
        OnNewCdpsSuccess(
          cdps: tCdpsUpdated, 
          featuresSelection: const [false, false], 
          canUpdate: false
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
          .thenAnswer((_) async => Left(BudgetsFailure(
            message: tErrorMessage, 
            exception: const ServerException(
              type: ServerExceptionType.NORMAL
            )
          )));
    });

    test('should call the specified methods', ()async{
      budgetsBloc.add(UpdateCdpsEvent());
      await untilCalled(updateCdps(any));
      verify(updateCdps(tCdpsInit));
      verifyNever(getCdps());
    });

    test('should emit the expected ordered states', ()async{
      final states = [
        OnLoadingBudgets(),
        OnNewCdpsError(
          cdps: tCdpsInit, 
          featuresSelection: tFeaturesSelectionInit, 
          canUpdate: true,
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
          .thenAnswer((_) async => const Left(BudgetsFailure(
            message: '', 
            exception: ServerException(
              type: ServerExceptionType.NORMAL
            )
          )));
    });

    test('should call the specified methods', ()async{
      budgetsBloc.add(UpdateCdpsEvent());
      await untilCalled(updateCdps(any));
      verify(updateCdps(tCdpsInit));
      verifyNever(getCdps());
    });

    test('should emit the expected ordered states', ()async{
      final states = [
        OnLoadingBudgets(),
        OnNewCdpsError(
          cdps: tCdpsInit, 
          featuresSelection: tFeaturesSelectionInit, 
          canUpdate: true,
          message: BudgetsBloc.generalErrorMessage
        )
      ];
      expectLater(budgetsBloc.stream, emitsInOrder(states));
      budgetsBloc.add(UpdateCdpsEvent());
    });
  });

  
}