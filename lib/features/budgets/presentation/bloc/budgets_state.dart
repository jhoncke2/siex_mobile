import 'package:equatable/equatable.dart';
import '../../domain/entities/budget.dart';

abstract class BudgetsState extends Equatable{
  @override
  List<Object?> get props => [runtimeType];
}
class OnBudgetsInit extends BudgetsState{

}
class OnLoadingBudgets extends BudgetsState{

}

class OnLoadingBudgetsFailure extends BudgetsState{
  final String message;
  OnLoadingBudgetsFailure({
    required this.message
  });
  @override
  List<Object?> get props => [message];
}

class OnBudgetsLoaded extends BudgetsState{
  final List<Budget> budgets;
  OnBudgetsLoaded({
    required this.budgets
  });
  @override
  List<Object?> get props => [...super.props, budgets];
}

class OnBudgetUpdating extends BudgetsState{
  final Budget budget;
  final List<bool> featuresSelection;
  final bool canEnd;
  OnBudgetUpdating({
    required this.budget,
    required this.featuresSelection,
    required this.canEnd
  });
  @override
  List<Object?> get props => [...super.props, budget, featuresSelection, canEnd];
}