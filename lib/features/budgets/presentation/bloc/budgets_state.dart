import 'package:equatable/equatable.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
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

abstract class OnCdps extends BudgetsState{
  final CdpsGroup cdps;
  final List<bool> featuresSelection;
  final bool canUpdateNewCdps;
  OnCdps({
    required this.featuresSelection,
    required this.cdps,
    required this.canUpdateNewCdps
  });
  @override
  List<Object?> get props => [
    ...super.props, 
    featuresSelection,
    cdps,
    canUpdateNewCdps
  ];
}

class OnOldCdps extends OnCdps{
  OnOldCdps({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps
  });
}

abstract class OnNewCdps extends OnCdps{
  OnNewCdps({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps
  });
}

class OnNewCdpsSuccess extends OnNewCdps{
  OnNewCdpsSuccess({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps
  });
}

class OnNewCdpsError extends OnNewCdps{
  final String message;
  OnNewCdpsError({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps,
    required this.message
  });
  @override
  List<Object?> get props => [...super.props, message];
}