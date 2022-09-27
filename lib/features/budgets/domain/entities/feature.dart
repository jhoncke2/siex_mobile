// ignore_for_file: constant_identifier_names, must_be_immutable
import 'package:equatable/equatable.dart';

enum FeatureState{
  Permitted,
  Denied,
  Returned
}

class Feature extends Equatable{
  final int id;
  final String name;
  final DateTime date;
  final double price;
  FeatureState? state;
  Feature({
    required this.id, 
    required this.name, 
    required this.state,
    required this.date,
    required this.price
  });
  @override
  List<Object?> get props => [id, name, [date.year, date.month, date.day], price, state];
}