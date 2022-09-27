import 'package:siex/features/budgets/data/budgets_remote_data_source.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';

class BudgetsRemoteDataSourceFake implements BudgetsRemoteDataSource{
  final List<Budget> budgets = [
    Budget(
      id: 0, 
      name: 'Cdps', 
      completed: false, 
      features: [
        Feature(id: 100, name: '2.1.2.001', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 101, name: '2.1.2.002', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 102, name: '2.1.2.003', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 103, name: '2.1.2.004', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 104, name: '2.1.2.005', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 105, name: '2.1.2.006', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 106, name: '2.1.2.007', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 107, name: '2.1.2.008', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 108, name: '2.1.2.009', state: null, date: DateTime.now(), price: 2000000)
      ]
    ),
    Budget(
      id: 1, 
      name: 'Registros', 
      completed: false, 
      features: [
        Feature(id: 200, name: '2.1.2.011', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 201, name: '2.1.2.012', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 202, name: '2.1.2.013', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 203, name: '2.1.2.014', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 204, name: '2.1.2.015', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 205, name: '2.1.2.016', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 206, name: '2.1.2.017', state: null, date: DateTime.now(), price: 2000000)
      ]
    ),
    Budget(
      id: 2, 
      name: 'Orden de pagos', 
      completed: false, 
      features: [
        Feature(id: 300, name: '2.1.2.021', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 301, name: '2.1.2.022', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 302, name: '2.1.2.023', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 303, name: '2.1.2.024', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 304, name: '2.1.2.025', state: null, date: DateTime.now(), price: 2000000)
      ]
    ),
    Budget(
      id: 0, 
      name: 'Pagos', 
      completed: false, 
      features: [
        Feature(id: 100, name: '2.1.2.031', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 101, name: '2.1.2.032', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 102, name: '2.1.2.033', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 103, name: '2.1.2.034', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 104, name: '2.1.2.035', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 105, name: '2.1.2.036', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 106, name: '2.1.2.037', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 107, name: '2.1.2.038', state: null, date: DateTime.now(), price: 2000000),
        Feature(id: 108, name: '2.1.2.039', state: null, date: DateTime.now(), price: 2000000)
      ]
    )
  ];

  @override
  Future<List<Budget>> getBudgets()async{
    return budgets;
  }

  @override
  Future<void> updateBudget(Budget budget)async{
    final index = budgets.indexWhere((b) => b.id == budget.id);
    budgets[index] = budget;
  }
  
}