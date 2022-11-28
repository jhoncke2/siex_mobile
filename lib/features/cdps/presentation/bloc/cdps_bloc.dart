import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_event.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_state.dart';
import 'package:siex/features/cdps/presentation/use_cases/get_cdps.dart';
import 'package:siex/features/cdps/presentation/use_cases/update_cdps.dart';

class CdpsBloc extends Bloc<CdpsEvent, CdpsState>{
  static const generalErrorMessage = 'Ha ocurrido un error inesperado';
  final GetCdps getCdps;
  final UpdateCdps updateCdps;
  CdpsBloc({
    required this.getCdps,
    required this.updateCdps
  }) : super(OnCdpsInit()){
    on<CdpsEvent>((event, emit)async{
      if(event is ChangeFeatureSelectionEvent){
        _changeFeatureSelection(event, emit);
      }else if(event is UpdateFeatureEvent){
        await _updateFeature(event, emit);
      }else if(event is LoadCdpsEvent){
        await _loadCdps(emit);
      }else if(event is ChangeCdpsTypeEvent){
        _changeCdpsType(event, emit);
      }else if(event is UpdateCdpsEvent){
        await _updateCdps(emit);
      }
    });
  }

  void _changeFeatureSelection(ChangeFeatureSelectionEvent event, Emitter<CdpsState> emit){
    final onCdpsState = (state as OnCdps);
    final newSelection = List<bool>.from(onCdpsState.featuresSelection);
    newSelection[event.index] = !newSelection[event.index];
    if(onCdpsState is OnNewCdps){
      emit(OnNewCdpsSuccess(
        cdps: onCdpsState.cdps, 
        featuresSelection: newSelection, 
        canUpdateNewCdps: onCdpsState.canUpdateNewCdps
      ));
    }else{
      emit(OnOldCdps(
        cdps: onCdpsState.cdps, 
        featuresSelection: newSelection,
        canUpdateNewCdps: onCdpsState.canUpdateNewCdps
      ));
    }
  }

  Future<void> _updateFeature(UpdateFeatureEvent event, Emitter<CdpsState> emit)async{
    final cdpsGroup = (state as OnNewCdps).cdps;
    final newCdps = List.of(cdpsGroup.newCdps);
    final cdp = newCdps[event.index];
    newCdps[event.index] = Feature(
      id: cdp.id, 
      name: cdp.name, 
      date: cdp.date, 
      price: cdp.price,
      pdfUrl: cdp.pdfUrl,
      state: event.newState
    );
    final cdpsUpdated = CdpsGroup(newCdps: newCdps, oldCdps: cdpsGroup.oldCdps);
    emit(OnNewCdpsSuccess(
      cdps: cdpsUpdated,
      featuresSelection: (state as OnNewCdps).featuresSelection,
      canUpdateNewCdps: true
    ));
  }

  Future<void> _loadCdps(Emitter<CdpsState> emit)async{
    emit(OnLoadingCdps());
    final result = await getCdps();
    result.fold((failure){

    }, (cdps){
      emit(OnNewCdpsSuccess(
        cdps: cdps, 
        canUpdateNewCdps: false,
        featuresSelection: cdps.newCdps.map<bool>(
          (_) => false
        ).toList()
      ));
    });
  }

  void _changeCdpsType(ChangeCdpsTypeEvent event, Emitter<CdpsState> emit)async{
    final onCdpsState = state as OnCdps;
    if(event.type == CdpsType.newType){
      emit(OnNewCdpsSuccess(
        cdps: onCdpsState.cdps,
        featuresSelection: onCdpsState.cdps.newCdps.map<bool>(
          (_) => false
        ).toList(),
        canUpdateNewCdps: onCdpsState.canUpdateNewCdps
      ));
    }else{
      emit(OnOldCdps(
        cdps: onCdpsState.cdps, 
        featuresSelection: onCdpsState.cdps.oldCdps.map<bool>(
          (_) => false
        ).toList(),
        canUpdateNewCdps: onCdpsState.canUpdateNewCdps
      ));
    }
  }

  Future<void> _updateCdps(Emitter<CdpsState> emit)async{
    final onCdpsState = (state as OnNewCdps);
    emit(OnLoadingCdps());
    final updateResult = await updateCdps(onCdpsState.cdps.newCdps);
    await updateResult.fold((failure)async{
      final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
      emit(OnNewCdpsError(
        cdps: onCdpsState.cdps, 
        canUpdateNewCdps: onCdpsState.canUpdateNewCdps, 
        featuresSelection: onCdpsState.featuresSelection, 
        message: message
      ));
    }, (_)async{
      final newCdpsResult = await getCdps();
      newCdpsResult.fold((failure){
        final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
        emit(OnNewCdpsError(
          cdps: onCdpsState.cdps, 
          canUpdateNewCdps: onCdpsState.canUpdateNewCdps, 
          featuresSelection: onCdpsState.featuresSelection, 
          message: message
        ));
      }, (cdpsUpdated){
        emit(OnNewCdpsSuccess(
          cdps: cdpsUpdated,
          featuresSelection: cdpsUpdated.newCdps.map(
            (_) => false
          ).toList(), 
          canUpdateNewCdps: false
        ));
      });
    });
  }
}