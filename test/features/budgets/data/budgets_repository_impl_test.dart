import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:siex/features/budgets/data/budgets_remote_data_source.dart';
import 'package:siex/features/budgets/data/budgets_repository_impl.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import 'budgets_repository_impl_test.mocks.dart';

late BudgetsRepositoryImpl budgetsRepository;
late MockBudgetsRemoteDataSource remoteDataSource;

@GenerateMocks([
  BudgetsRemoteDataSource
])
void main(){
  setUp((){
    remoteDataSource = MockBudgetsRemoteDataSource();
    budgetsRepository = BudgetsRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('get budgets', _testGetBudgetsGroup);
  group('update budget', _testUpdateBudgetGroup);
}

void _testGetBudgetsGroup(){
  late List<Budget> tBudgets;
  setUp((){
    tBudgets = [
      Budget(
        id: 0, 
        name: 'budget_0',
        completed: true,
        features: [
          Feature(id: 100, name: 'f_100', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
          Feature(id: 101, name: 'f_101', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000)
        ]
      ),
      Budget(
        id: 1, 
        name: 'budget_1',
        completed: true,
        features: [
          Feature(id: 100, name: 'f_100', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
          Feature(id: 101, name: 'f_101', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000)
        ]
      )
    ];
    when(remoteDataSource.getBudgets()).thenAnswer((_) async => tBudgets);
  });
  
  test('should call the specified methods', ()async{
    await budgetsRepository.getBudgets();
    verify(remoteDataSource.getBudgets());
  });
  
  test('shold return the expected result', ()async{
    final result = await budgetsRepository.getBudgets();
    expect(result, Right(tBudgets));
  });
}
void _testUpdateBudgetGroup(){
  late Budget tBudget;
  setUp((){
    tBudget = Budget(
      id: 1, 
      name: 'budget_1',
      completed: true,
      features: [
        Feature(id: 100, name: 'f_100', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
        Feature(id: 101, name: 'f_101', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000)
      ]
    );
  });
  
  test('should call the specified methods', ()async{
    await budgetsRepository.updateBudget(tBudget);
    verify(remoteDataSource.updateBudget(tBudget));
  });
  
  test('shold return the expected result', ()async{
    final result = await budgetsRepository.updateBudget(tBudget);
    expect(result, const Right(null));
  });
}