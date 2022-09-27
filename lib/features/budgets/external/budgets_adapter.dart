import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';

class BudgetAdapter{
  List<Budget> getBudgetsFromJson(List<Map<String, dynamic>> jsonList) => jsonList.map(
    (json) => getBudgetFromJson(json) 
  ).toList();

  Budget getBudgetFromJson(Map<String, dynamic> json) => Budget(
    id: json['id'], 
    name: json['name'],
    completed: json['completed'],
    features: getFeaturesFromMap((json['features'] as List).cast<Map<String, dynamic>>())
  );

  List<Feature> getFeaturesFromMap(List<Map<String, dynamic>> jsonList) => jsonList.map(
    (json) => getFeatureFromJson(json) 
  ).toList();
  
  Feature getFeatureFromJson(Map<String, dynamic> json){
    final dateParts = (json['date'] as String)
        .split('-')
        .map<int>(
          (p) => int.parse(p)
        ).toList();
    return Feature(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      price: json['price'],
      date: DateTime(dateParts[0], dateParts[1], dateParts[2])
    );
  }
}