// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/time_state.dart';

class Record extends Equatable{
  final int id;
  final String name;
  final DateTime date;
  final double price;
  final String pdfUrl;
  final String cdpName;
  TimeState? state;
  Record({
    required this.id, 
    required this.name, 
    required this.state,
    required this.date,
    required this.price,
    required this.cdpName,
    required this.pdfUrl
  });
  @override
  List<Object?> get props => [
    id,
    name,
    [date.year, date.month, date.day],
    price,
    pdfUrl,
    cdpName,
    state
  ];
}