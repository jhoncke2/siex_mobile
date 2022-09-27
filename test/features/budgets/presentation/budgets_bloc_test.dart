import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_bloc.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_event.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_state.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_budgets.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_budget.dart';
import 'budgets_bloc_test.mocks.dart';

late BudgetsBloc budgetsBloc;
late MockGetBudgets getBudgets;
late MockUpdateBudget updateBudget;

@GenerateMocks([
  GetBudgets,
  UpdateBudget
])
void main(){
  setUp((){
    updateBudget = MockUpdateBudget();
    getBudgets = MockGetBudgets();
    budgetsBloc = BudgetsBloc(
      getBudgets: getBudgets, 
      updateBudget: updateBudget
    );
  });
  
  group('load budgets', _testLoadBudgetsGroup);
  group('select budget', _testSelectBudgetGroup);
  group('change feature selection', _testChangeFeatureSelectionGroup);
  group('update feature', _testUpdateFeatureGroup);
  group('end budget updating', _testEndBudgetUpdatingGroup);
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
  late Budget tBudget;
  late List<bool> tSelectionInit;
  setUp((){
    tBudget = Budget(
      id: 1, 
      name: 'budget_0',
      completed: false,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
      ]
    );
  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is unselected', ()async{
    tSelectionInit = [false, true, false];
    budgetsBloc.emit(OnBudgetUpdating(budget: tBudget, featuresSelection: tSelectionInit, canEnd: false));
    final expectedOrderedStates = [
      OnBudgetUpdating(budget: tBudget, featuresSelection: const [true, true, false], canEnd: false)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the first and it is selected', ()async{
    tSelectionInit = [true, true, false];
    budgetsBloc.emit(OnBudgetUpdating(budget: tBudget, featuresSelection: tSelectionInit, canEnd: false));
    final expectedOrderedStates = [
      OnBudgetUpdating(budget: tBudget, featuresSelection: const [false, true, false], canEnd: false)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 0));
  });

  test('shold yield the expected ordered states when the selection updated feature is the second and it is selected', ()async{
    tSelectionInit = [true, true, false];
    budgetsBloc.emit(OnBudgetUpdating(budget: tBudget, featuresSelection: tSelectionInit, canEnd: false));
    final expectedOrderedStates = [
      OnBudgetUpdating(budget: tBudget, featuresSelection: const [true, false, false], canEnd: false)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(ChangeFeatureSelectionEvent(index: 1));
  });
}

void _testUpdateFeatureGroup(){
  late Budget tBudgetInit;
  late Budget tBudgetUpdated;
  late List<bool> tFeaturesSelection;

  test('should emit the expected ordered states when the budget is not completed after updating the first feature state to Permitted and with features selection config 1', ()async{
    tBudgetInit = Budget(
      id: 0, 
      name: 'budget_0',
      completed: false,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
      ]
    );
    tBudgetUpdated = Budget(
      id: 0, 
      name: 'budget_0',
      completed: false,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
      ]
    );
    tFeaturesSelection = [false, true, false];
    budgetsBloc.emit(OnBudgetUpdating(budget: tBudgetInit, featuresSelection: tFeaturesSelection, canEnd: false));
    final expectedOrderedStates = [
      OnBudgetUpdating(budget: tBudgetUpdated, featuresSelection: tFeaturesSelection, canEnd: false)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(UpdateFeatureEvent(index: 0, newState: FeatureState.Permitted));
  });

  test('should emit the expected ordered states when the budget is not completed after updating the first feature state to Denied and with features selection config 2', ()async{
    tBudgetInit = Budget(
      id: 0, 
      name: 'budget_0',
      completed: false,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
      ]
    );
    tBudgetUpdated = Budget(
      id: 0, 
      name: 'budget_0',
      completed: false,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Denied),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
      ]
    );
    tFeaturesSelection = [false, false, true];
    budgetsBloc.emit(OnBudgetUpdating(budget: tBudgetInit, featuresSelection: tFeaturesSelection, canEnd: false));
    final expectedOrderedStates = [
      OnBudgetUpdating(budget: tBudgetUpdated, featuresSelection: tFeaturesSelection, canEnd: false)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(UpdateFeatureEvent(index: 0, newState: FeatureState.Denied));
  });

  test('should emit the expected ordered states when the budget is not completed after updating the third feature state to Returned and with features selection config 3', ()async{
    tBudgetInit = Budget(
      id: 0, 
      name: 'budget_0',
      completed: false,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
      ]
    );
    tBudgetUpdated = Budget(
      id: 0, 
      name: 'budget_0',
      completed: false,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: null),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: FeatureState.Returned)
      ]
    );
    tFeaturesSelection = [true, true, true];
    budgetsBloc.emit(OnBudgetUpdating(budget: tBudgetInit, featuresSelection: tFeaturesSelection, canEnd: false));
    final expectedOrderedStates = [
      OnBudgetUpdating(budget: tBudgetUpdated, featuresSelection: tFeaturesSelection, canEnd: false)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(UpdateFeatureEvent(index: 2, newState: FeatureState.Returned));
  });

  test('should emit the expected ordered states when the budget is Indeed completed after updating the third feature state to Permitted and with features selection config 4', ()async{
    tBudgetInit = Budget(
      id: 0, 
      name: 'budget_0',
      completed: false,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Returned),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: null)
      ]
    );
    tBudgetUpdated = Budget(
      id: 0, 
      name: 'budget_0',
      completed: true,
      features: [
        Feature(id: 100, name: 'f_100', date: DateTime.now(), price: 2000000, state: FeatureState.Returned),
        Feature(id: 101, name: 'f_101', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted),
        Feature(id: 102, name: 'f_102', date: DateTime.now(), price: 2000000, state: FeatureState.Permitted)
      ]
    );
    tFeaturesSelection = [false, false, false];
    budgetsBloc.emit(OnBudgetUpdating(budget: tBudgetInit, featuresSelection: tFeaturesSelection, canEnd: false));
    final expectedOrderedStates = [
      OnBudgetUpdating(budget: tBudgetUpdated, featuresSelection: tFeaturesSelection,canEnd: true)
    ];
    expectLater(budgetsBloc.stream, emitsInOrder(expectedOrderedStates));
    budgetsBloc.add(UpdateFeatureEvent(index: 2, newState: FeatureState.Permitted));
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