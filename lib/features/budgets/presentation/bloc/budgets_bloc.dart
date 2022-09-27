import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_event.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_state.dart';
import 'package:siex/features/budgets/presentation/use_cases/get_budgets.dart';
import 'package:siex/features/budgets/presentation/use_cases/update_budget.dart';

class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState>{
  final GetBudgets getBudgets;
  final UpdateBudget updateBudget;
  BudgetsBloc({
    required this.getBudgets,
    required this.updateBudget,
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
    final onUpdatingState = (state as OnBudgetUpdating);
    final newSelection = List<bool>.from(onUpdatingState.featuresSelection);
    newSelection[event.index] = !newSelection[event.index];
    emit(OnBudgetUpdating(budget: onUpdatingState.budget, featuresSelection: newSelection, canEnd: onUpdatingState.canEnd));
  }

  bool _featuresAreCompleted(List<Feature> features) => features.every((f) => f.state != null);

  Future<void> _updateFeature(UpdateFeatureEvent event, Emitter<BudgetsState> emit)async{
    final onUpdatingState = (state as OnBudgetUpdating);
    final budget = onUpdatingState.budget;
    final features = List.of(budget.features);
    final feature = features[event.index];
    features[event.index] = Feature(id: feature.id, name: feature.name, date: feature.date, price: feature.price, state: event.newState);
    final completed = _featuresAreCompleted(features);
    final newBudget = Budget(id: budget.id, name: budget.name, completed: completed, features: features);
    emit(OnBudgetUpdating(budget: newBudget, featuresSelection: onUpdatingState.featuresSelection, canEnd: completed));
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
}