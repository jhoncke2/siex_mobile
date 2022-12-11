import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/presentation/use_cases/get_new_records.dart';
import 'package:siex/features/records/presentation/use_cases/get_old_records.dart';
import 'package:siex/features/records/presentation/use_cases/update_records.dart';
import '../../../../core/domain/entities/time_state.dart';
import '../../domain/records_failure.dart';

part 'records_event.dart';
part 'records_state.dart';

class RecordsBloc extends Bloc<RecordsEvent, RecordsState> {
  static const generalErrorMessage = 'Ha ocurrido un error inesperado';

  final GetNewRecords getNewRecords;
  final GetOldRecords getOldRecords;
  final UpdateRecords updateRecords;
  RecordsBloc({
    required this.getNewRecords,
    required this.getOldRecords,
    required this.updateRecords
  }) : super(OnRecordsInitial()) {
    on<RecordsEvent>((event, emit)async{
      if(event is LoadNewRecordsEvent){
        await _loadNewRecords(emit);
      }else if(event is LoadOldRecordsEvent){
        await _loadOldRecords(emit);
      }else if(event is UpdateRecordStateEvent){
        _updateRecordState(event, emit);
      }else if(event is ChangeRecordsSelectionEvent){
        _changeRecordsSelection(event, emit);
      }else if(event is UpdateNewRecordsEvent){
        await _updateNewRecords(emit);
      }
    });
  }

  Future<void> _loadNewRecords(Emitter<RecordsState> emit)async{
    emit(const OnLoadingRecords());
    final result = await getNewRecords();
    result.fold((failure){
      final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
      emit(OnLoadingRecordsError(message: message));
    }, (records){
      final recordsSelection = records.map(
        (r) => false
      ).toList();
      emit(OnNewRecordsSuccess(
        records: records,
        recordsSelection: recordsSelection,
        canUpdateRecords: false
      ));
    });
  }

  Future<void> _loadOldRecords(Emitter<RecordsState> emit)async{
    final newRecords = (state as OnNewRecords).records;
    final newRecordsSelection = (state as OnNewRecords).recordsSelection;
    final newRecordCanBeUpdate = (state as OnNewRecords).canUpdateRecords;
    emit(const OnLoadingRecords());
    final result = await getOldRecords();
    await result.fold((failure)async{
      final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
      emit(OnNewRecordsError(
        records: newRecords, 
        recordsSelection: newRecordsSelection, 
        canUpdateRecords: newRecordCanBeUpdate, 
        message: message
      ));
    }, (records)async{
      final recordsSelection = records.map(
        (r) => false
      ).toList();
      emit(OnOldRecordsSuccess(
        records: records,
        recordsSelection: recordsSelection,
      ));
    });
  }

  void _updateRecordState(UpdateRecordStateEvent event, Emitter<RecordsState> emit){
    final currentRecords = (state as OnNewRecords).records;
    final records = List.of(currentRecords);
    final record = records[event.index];
    records[event.index] = Record(
      id: record.id, 
      name: record.name, 
      date: record.date, 
      price: record.price,
      pdfUrl: record.pdfUrl,
      state: event.newState,
      cdpName: record.cdpName
    );
    emit(OnNewRecordsSuccess(
      records: records,
      recordsSelection: (state as OnNewRecords).recordsSelection,
      canUpdateRecords: true
    ));
  }

  void _changeRecordsSelection(ChangeRecordsSelectionEvent event, Emitter<RecordsState> emit){
    final onRecordsState = (state as OnRecords);
    final newSelection = List<bool>.from(onRecordsState.recordsSelection);
    newSelection[event.index] = !newSelection[event.index];
    if(onRecordsState is OnNewRecords){
      emit(OnNewRecordsSuccess(
        records: onRecordsState.records,
        recordsSelection: newSelection,
        canUpdateRecords: onRecordsState.canUpdateRecords
      ));
    }else{
      emit(OnOldRecordsSuccess(
        records: onRecordsState.records,
        recordsSelection: newSelection
      ));
    }
  }

  Future<void> _updateNewRecords(Emitter<RecordsState> emit)async{
    final recordsInit = (state as OnNewRecords).records;
    final recordsSelectionInit = (state as OnNewRecords).recordsSelection;
    emit(const OnLoadingRecords());
    final updateResult = await updateRecords(recordsInit);
    await updateResult.fold((updateFailure)async{
      _manageUpdateFailure(updateFailure, emit, recordsInit, recordsSelectionInit);
    }, (_)async{
      final newRecordsResult = await getNewRecords();
      newRecordsResult.fold((newRecordsFailure){
        _manageUpdateFailure(newRecordsFailure, emit, recordsInit, recordsSelectionInit);
      }, (recordsUpdated){
        final recordsSelectionUpdated = recordsUpdated.map(
          (r) => false
        ).toList();
        emit(OnNewRecordsSuccess(
          records: recordsUpdated, 
          recordsSelection: recordsSelectionUpdated, 
          canUpdateRecords: false
        ));
      });
    });
  }

  void _manageUpdateFailure(RecordsFailure failure, Emitter<RecordsState> emit, List<Record> records, List<bool> selection)async{
    final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
    emit(OnNewRecordsError(
      records: records, 
      recordsSelection: selection, 
      canUpdateRecords: true, 
      message: message
    ));
  }
}
