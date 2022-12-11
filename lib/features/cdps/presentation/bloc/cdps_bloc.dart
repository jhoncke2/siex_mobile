import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_event.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_state.dart';
import 'package:siex/features/cdps/presentation/use_cases/get_cdp_pdf.dart';
import 'package:siex/features/cdps/presentation/use_cases/get_cdps.dart';
import 'package:siex/features/cdps/presentation/use_cases/update_cdps.dart';

class CdpsBloc extends Bloc<CdpsEvent, CdpsState>{
  static const generalErrorMessage = 'Ha ocurrido un error inesperado';
  final GetCdps getCdps;
  final UpdateCdps updateCdps;
  final GetCdpPdf getCdpPdf;
  CdpsBloc({
    required this.getCdps,
    required this.updateCdps,
    required this.getCdpPdf
  }) : super(OnCdpsInit()){
    on<CdpsEvent>((event, emit)async{
      if(event is ChangeCdpSelectionEvent){
        _changeCdpSelection(event, emit);
      }else if(event is UpdateSingleCdpEvent){
        await _updateSingleCdp(event, emit);
      }else if(event is LoadCdpsEvent){
        await _loadCdps(emit);
      }else if(event is ChangeCdpsTypeEvent){
        _chooseCdpsType(event, emit);
      }else if(event is UpdateCdpsEvent){
        await _updateCdps(emit);
      }else if(event is LoadCdpPdfEvent){
        await _loadCdpPdf(event, emit);
      }else if(event is BackToCdpsEvent){
        _backToCdps(emit);
      }
    });
  }

  void _changeCdpSelection(ChangeCdpSelectionEvent event, Emitter<CdpsState> emit){
    final onCdpsState = (state as OnShowingCdps);
    final newSelection = List<bool>.from(onCdpsState.featuresSelection);
    newSelection[event.index] = !newSelection[event.index];
    if(onCdpsState is OnNewCdps){
      emit(OnNewCdpsSuccess(
        cdps: onCdpsState.cdps, 
        featuresSelection: newSelection, 
        canUpdateNewCdps: onCdpsState.canUpdateNewCdps
      ));
    }else{
      emit(OnOldCdpsSuccess(
        cdps: onCdpsState.cdps, 
        featuresSelection: newSelection,
        canUpdateNewCdps: onCdpsState.canUpdateNewCdps
      ));
    }
  }

  Future<void> _updateSingleCdp(UpdateSingleCdpEvent event, Emitter<CdpsState> emit)async{
    final cdpsGroup = (state as OnNewCdps).cdps;
    final newCdps = List.of(cdpsGroup.newCdps);
    final cdp = newCdps[event.index];
    newCdps[event.index] = Cdp(
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
    final currentState = state;
    emit(OnLoadingOnCdps());
    final result = await getCdps();
    result.fold((failure){
      _manageLoadCdpsError(emit, currentState, failure.message);
    }, (cdps){
      if(currentState is OnOldCdps){
        emit(OnOldCdpsSuccess(
          cdps: cdps, 
          featuresSelection: _getNewFeaturesSelectionFromCdps(cdps.oldCdps), 
          canUpdateNewCdps: false
        ));
      }else{
        emit(OnNewCdpsSuccess(
          cdps: cdps, 
          canUpdateNewCdps: false,
          featuresSelection: _getNewFeaturesSelectionFromCdps(cdps.newCdps)
        ));
      }
    });
  }

  void _manageLoadCdpsError(Emitter<CdpsState> emit, CdpsState currentState, String errorMessage){
    final message = (errorMessage.isNotEmpty)? errorMessage : generalErrorMessage;
    if(currentState is OnCdpsInit){
      emit(OnLoadingCdpsFailure(
        message: message
      ));
    }else{
      final onCdpsState = currentState as OnCdps;
      if(onCdpsState is OnNewCdps){
        emit(OnNewCdpsError(
          cdps: onCdpsState.cdps, 
          featuresSelection: onCdpsState.featuresSelection, 
          canUpdateNewCdps: onCdpsState.canUpdateNewCdps, 
          message: message
        ));
      }else{
        emit(OnOldCdpsError(
          cdps: onCdpsState.cdps, 
          featuresSelection: onCdpsState.featuresSelection, 
          canUpdateNewCdps: onCdpsState.canUpdateNewCdps, 
          message: message
        ));
      }
    }
  }

  List<bool> _getNewFeaturesSelectionFromCdps(List<Cdp> cdps) =>
      cdps.map<bool>(
        (_) => false
      ).toList();

  void _chooseCdpsType(ChangeCdpsTypeEvent event, Emitter<CdpsState> emit)async{
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
      emit(OnOldCdpsSuccess(
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
    emit(OnLoadingOnCdps());
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

  Future<void> _loadCdpPdf(LoadCdpPdfEvent event, Emitter<CdpsState> emit)async{
    final cdps = (state as OnShowingCdps).cdps;
    final featuresSelection = (state as OnShowingCdps).featuresSelection;
    final canUpdateNewCdps = (state as OnShowingCdps).canUpdateNewCdps;
    final cdpsType = (state is OnNewCdps)? CdpsType.newType : CdpsType.oldType;
    emit(OnLoadingOnCdps());
    final pdfResult = await getCdpPdf(event.cdp);
    pdfResult.fold((failure){
      final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
      if(cdpsType == CdpsType.newType){
        emit(OnNewCdpsError(
          cdps: cdps, 
          featuresSelection: featuresSelection, 
          canUpdateNewCdps: canUpdateNewCdps, 
          message: message
        ));
      }else{
        emit(OnOldCdpsError(
          cdps: cdps, 
          featuresSelection: featuresSelection, 
          canUpdateNewCdps: canUpdateNewCdps,
          message: message
        ));
      }
    }, (pdf){
       emit(OnCdpPdf(
        pdf: pdf, 
        cdpsType: cdpsType, 
        cdps: cdps, 
        featuresSelection: featuresSelection, 
        canUpdateNewCdps: canUpdateNewCdps
      ));
    });
  }

  void _backToCdps(Emitter<CdpsState> emit){
    final cdps = (state as OnCdpPdf).cdps;
    final featuresSelection = (state as OnCdpPdf).featuresSelection;
    final canUpdateNewCdps = (state as OnCdpPdf).canUpdateNewCdps;
    final cdpsType = (state as OnCdpPdf).cdpsType;
    if(cdpsType == CdpsType.newType){
      emit(OnNewCdpsSuccess(
        cdps: cdps, 
        featuresSelection: featuresSelection, 
        canUpdateNewCdps: canUpdateNewCdps
      ));
    }else{
      emit(OnOldCdpsSuccess(
        cdps: cdps, 
        featuresSelection: featuresSelection, 
        canUpdateNewCdps: canUpdateNewCdps
      ));
    }
  }
}