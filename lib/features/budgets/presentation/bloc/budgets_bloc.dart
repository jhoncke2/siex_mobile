import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_event.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_state.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_budgets.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_cdps.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_budget.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_cdps.dart';

class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState>{
  static const generalErrorMessage = 'Ha ocurrido un error inesperado';
  final GetBudgets getBudgets;
  final UpdateBudget updateBudget;
  final GetCdps getCdps;
  final UpdateCdps updateCdps;
  BudgetsBloc({
    required this.getBudgets,
    required this.updateBudget,
    required this.getCdps,
    required this.updateCdps
  }) : super(OnBudgetsInit()){
    on<BudgetsEvent>((event, emit)async{
      if(event is LoadBudgetsEvent){
        await _loadBudgets(emit);
      }else if(event is SelectBudgetEvent){
        await _selectBudget(event, emit);
      }else if(event is ChangeFeatureSelectionEvent){
        _changeFeatureSelection(event, emit);
      }else if(event is UpdateFeatureEvent){
        await _updateFeature(event, emit);
      }else if(event is EndBudgetUpdating){
        await _endBudgetUpdating(emit);
      }else if(event is LoadCdpsEvent){
        await _loadCdps(emit);
      }else if(event is UpdateCdpsEvent){
        await _updateCdps(emit);
      }
    });
  }
  
  Future<void> _loadBudgets(Emitter<BudgetsState> emit)async{
    emit(OnLoadingBudgets());
    final eitherBudgets = await getBudgets();
    eitherBudgets.fold((failure){

    }, (budgets){
      emit(OnBudgetsLoaded(budgets: budgets));
    });
  }
  
  Future<void> _selectBudget(SelectBudgetEvent event, Emitter<BudgetsState> emit)async{
    final budget = event.budget;
    final featuresSelection = event.budget.features.map<bool>(
      (f) => false
    ).toList();
    emit(OnBudgetUpdating(budget: budget, featuresSelection: featuresSelection, canEnd: _featuresAreCompleted(budget.features)));
  }

  void _changeFeatureSelection(ChangeFeatureSelectionEvent event, Emitter<BudgetsState> emit){
    final onCdpsState = (state as OnNewCdps);
    final newSelection = List<bool>.from(onCdpsState.featuresSelection);
    newSelection[event.index] = !newSelection[event.index];
    emit(OnNewCdpsSuccess(cdps: onCdpsState.cdps, featuresSelection: newSelection, canUpdate: onCdpsState.canUpdate));
  }

  bool _featuresAreCompleted(List<Feature> features) => features.every((f) => f.state != null);

  Future<void> _updateFeature(UpdateFeatureEvent event, Emitter<BudgetsState> emit)async{
    final cdpsGroup = (state as OnNewCdps).cdps;
    final newCdps = List.of(cdpsGroup.newCdps);
    final cdp = newCdps[event.index];
    newCdps[event.index] = Feature(id: cdp.id, name: cdp.name, date: cdp.date, price: cdp.price, state: event.newState);
    final cdpsUpdated = CdpsGroup(newCdps: newCdps, oldCdps: cdpsGroup.oldCdps);
    emit(OnNewCdpsSuccess(
      cdps: cdpsUpdated,
      featuresSelection: (state as OnNewCdps).featuresSelection,
      canUpdate: true
    ));
  }

  Future<void> _endBudgetUpdating(Emitter<BudgetsState> emit)async{
    final budget = (state as OnBudgetUpdating).budget;
    emit(OnLoadingBudgets());
    await updateBudget(budget);
    final eitherNewBudgets = await getBudgets();
    eitherNewBudgets.fold((failure){

    }, (budgets){
      emit(OnBudgetsLoaded(budgets: budgets));
    });
  }

  Future<void> _loadCdps(Emitter<BudgetsState> emit)async{
    emit(OnLoadingBudgets());
    final result = await getCdps();
    result.fold((failure){

    }, (cdps){
      emit(OnNewCdpsSuccess(
        cdps: cdps, 
        canUpdate: false,
        featuresSelection: cdps.newCdps.map<bool>(
          (_) => false
        ).toList()
      ));
    });
  }

  Future<void> _updateCdps(Emitter<BudgetsState> emit)async{
    final onCdpsState = (state as OnNewCdps);
    emit(OnLoadingBudgets());
    final updateResult = await updateCdps(onCdpsState.cdps.newCdps);
    await updateResult.fold((failure)async{
      final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
      emit(OnNewCdpsError(
        cdps: onCdpsState.cdps, 
        canUpdate: onCdpsState.canUpdate, 
        featuresSelection: onCdpsState.featuresSelection, 
        message: message
      ));
    }, (_)async{
      final newCdpsResult = await getCdps();
      newCdpsResult.fold((failure){
        final message = (failure.message.isNotEmpty)? failure.message : generalErrorMessage;
        emit(OnNewCdpsError(
          cdps: onCdpsState.cdps, 
          canUpdate: onCdpsState.canUpdate, 
          featuresSelection: onCdpsState.featuresSelection, 
          message: message
        ));
      }, (cdpsUpdated){
        emit(OnNewCdpsSuccess(
          cdps: cdpsUpdated,
          featuresSelection: cdpsUpdated.newCdps.map(
            (_) => false
          ).toList(), 
          canUpdate: false
        ));
      });
    });
  }
}