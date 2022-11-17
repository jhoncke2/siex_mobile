import 'dart:convert';

import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';

class BudgetsAdapter{
  List<Budget> getBudgetsFromJson(List<Map<String, dynamic>> jsonList) => jsonList.map(
    (json) => getBudgetFromJson(json) 
  ).toList();

  Budget getBudgetFromJson(Map<String, dynamic> json) => Budget(
    id: json['id'], 
    name: json['name'],
    completed: json['completed'],
    features: getFeaturesFromMap((json['features'] as List).cast<Map<String, dynamic>>())
  );

  CdpsGroup getCdpsGroupFromStringBody(String body){
    final jsonBody = jsonDecode(body);
    final group = CdpsGroup(
      newCdps: _getCdpsFromJsonList(jsonBody['new']), 
      oldCdps: _getCdpsFromJsonList(jsonBody['old'])
    );
    return group;
  }

  List<Feature> _getCdpsFromJsonList(List<Map<String, dynamic>> jsonList) => (jsonList as List).map(
    (json) => _getCdpFromJson(json)
  ).toList();

  List<Feature> getOldCdpsFromStringBody(String body, String type){
    final jsonBody = jsonDecode(body);
    return (jsonBody['old'] as List).map(
      (json) => _getCdpFromJson(json)
    ).toList();
  }

  List<Feature> getNewCdpsFromStringBody(String body, String type){
    final jsonBody = jsonDecode(body);
    return (jsonBody['new'] as List).map(
      (json) => _getCdpFromJson(json)
    ).toList();
  }

  Feature _getCdpFromJson(Map<String, dynamic> json){
    final dateParts = (json['fecha'] as String)
        .split('-')
        .map<int>(
          (p) => int.parse(p)
        ).toList();
    return Feature(
      id: json['id'],
      name: json['name'],
      state: json['estado'],
      price: json['valor'],
      date: DateTime(dateParts[0], dateParts[1], dateParts[2])
    );
  }

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