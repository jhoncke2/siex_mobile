part of 'records_bloc.dart';

abstract class RecordsState extends Equatable {
  const RecordsState();
  
  @override
  List<Object> get props => [];
}

class OnRecordsInitial extends RecordsState {}

abstract class OnError{
  String get message;
}

class OnLoadingRecords extends RecordsState {
  const OnLoadingRecords();
}

class OnLoadingRecordsError extends OnLoadingRecords implements OnError{
  @override
  final String message;
  const OnLoadingRecordsError({
    required this.message
  });
  @override
  List<Object> get props => [
    ...super.props, 
    message
  ];
}

abstract class OnRecords extends RecordsState{
  final List<Record> records;
  final List<bool> recordsSelection;
  const OnRecords({
    required this.records,
    required this.recordsSelection
  });
  @override
  List<Object> get props => [
    ...super.props,
    records,
    recordsSelection
  ];
}

abstract class OnOldRecords extends OnRecords{
  const OnOldRecords({
    required super.records, 
    required super.recordsSelection
  });
}

class OnOldRecordsSuccess extends OnOldRecords{
  const OnOldRecordsSuccess({
    required super.records, 
    required super.recordsSelection
  });
}

class OnOldRecordsError extends OnOldRecords implements OnError{
  @override
  final String message;
  const OnOldRecordsError({
    required super.records, 
    required super.recordsSelection,
    required this.message
  });
  @override
  List<Object> get props => [
    ...super.props,
    message
  ];
}

abstract class OnNewRecords extends OnRecords {
  final bool canUpdateRecords;
  const OnNewRecords({
    required super.records, 
    required super.recordsSelection,
    required this.canUpdateRecords
  });
  @override
  List<Object> get props => [
    ...super.props,
    canUpdateRecords
  ];
}

class OnNewRecordsSuccess extends OnNewRecords{
  const OnNewRecordsSuccess({
    required super.records, 
    required super.recordsSelection,
    required super.canUpdateRecords
  });
}

class OnNewRecordsError extends OnNewRecords implements OnError{
  @override
  final String message;
  const OnNewRecordsError({
    required super.records, 
    required super.recordsSelection,
    required super.canUpdateRecords,
    required this.message
  });
  @override
  List<Object> get props => [
    ...super.props, 
    message
  ];
}
