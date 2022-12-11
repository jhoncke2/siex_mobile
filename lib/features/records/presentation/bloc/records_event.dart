part of 'records_bloc.dart';

abstract class RecordsEvent extends Equatable {
  const RecordsEvent();

  @override
  List<Object> get props => [];
}

class LoadNewRecordsEvent extends RecordsEvent{

}

class UpdateRecordStateEvent extends RecordsEvent{
  final int index;
  final TimeState newState;
  const UpdateRecordStateEvent({
    required this.index, 
    required this.newState
  });
}

class ChangeRecordsSelectionEvent extends RecordsEvent{
  final int index;
  const ChangeRecordsSelectionEvent({
    required this.index
  });
}

class LoadOldRecordsEvent extends RecordsEvent{

}

class UpdateNewRecordsEvent extends RecordsEvent{

}