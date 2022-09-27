// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';

class Budget extends Equatable{
  final int id;
  final String name;
  bool completed;
  final List<Feature> features;
  Budget({
    required this.id,
    required this.name,
    required this.completed,
    required this.features
  });
  @override
  List<Object?> get props => [id, name, completed, features];
}