import 'package:siex/features/budgets/data/budgets_remote_data_source.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';

class BudgetsRemoteDataSourceFake implements BudgetsRemoteDataSource{
  final List<Feature> newCdps = [
    Feature(id: 100, name: '2.1.2.001', state: null, date: DateTime.now(), price: 2000000),
    Feature(id: 101, name: '2.1.2.002', state: null, date: DateTime.now(), price: 2000000),
    Feature(id: 102, name: '2.1.2.003', state: null, date: DateTime.now(), price: 2000000),
    Feature(id: 103, name: '2.1.2.004', state: null, date: DateTime.now(), price: 2000000),
    Feature(id: 104, name: '2.1.2.005', state: null, date: DateTime.now(), price: 2000000),
    Feature(id: 105, name: '2.1.2.006', state: null, date: DateTime.now(), price: 2000000),
    Feature(id: 106, name: '2.1.2.007', state: null, date: DateTime.now(), price: 2000000),
    Feature(id: 107, name: '2.1.2.008', state: null, date: DateTime.now(), price: 2000000),
    Feature(id: 108, name: '2.1.2.009', state: null, date: DateTime.now(), price: 2000000)
  ];
  final List<Feature> oldCdps = [
    Feature(id: 1000, name: '2.1.2.010', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000),
    Feature(id: 1001, name: '2.1.2.020', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
    Feature(id: 1002, name: '2.1.2.030', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
    Feature(id: 1003, name: '2.1.2.040', state: FeatureState.Returned, date: DateTime.now(), price: 2000000),
    Feature(id: 1004, name: '2.1.2.050', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000),
    Feature(id: 1005, name: '2.1.2.060', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
    Feature(id: 1006, name: '2.1.2.070', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000),
    Feature(id: 1007, name: '2.1.2.080', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
    Feature(id: 1008, name: '2.1.2.090', state: FeatureState.Returned, date: DateTime.now(), price: 2000000),
    Feature(id: 1009, name: '2.1.2.100', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
    Feature(id: 1010, name: '2.1.2.110', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000),
    Feature(id: 1011, name: '2.1.2.120', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
    Feature(id: 1012, name: '2.1.2.130', state: FeatureState.Returned, date: DateTime.now(), price: 2000000),
    Feature(id: 1013, name: '2.1.2.140', state: null, date: DateTime.now(), price: 2000000),
    Feature(id: 1014, name: '2.1.2.150', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000),
    Feature(id: 1015, name: '2.1.2.160', state: FeatureState.Denied, date: DateTime.now(), price: 2000000),
    Feature(id: 1016, name: '2.1.2.170', state: FeatureState.Returned, date: DateTime.now(), price: 2000000),
    Feature(id: 1017, name: '2.1.2.180', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000)
  ];
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
  
  @override
  Future<List<Feature>> getNewCdps(String accessToken)async{
    return newCdps;
  }
  
  @override
  Future<void> updateCdps(List<Feature> cdps, String accessToken)async{
    await Future.delayed(const Duration(milliseconds: 1750));
    budgets.first.features.removeWhere((_) => true);
    budgets.first.features.addAll(
      cdps.where((cdp) => cdp.state == null)
    );
  }
  
  @override
  Future<List<Feature>> getOldCdps(String accesToken)async{
    return oldCdps;
  }

  @override
  Future<CdpsGroup> getCdps(String accessToken)async{
    return CdpsGroup(
      newCdps: newCdps, 
      oldCdps: oldCdps
    );
  }
}