import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';

class BudgetsEvent{

}

class LoadBudgetsEvent extends BudgetsEvent{

}

class SelectBudgetEvent extends BudgetsEvent{
  final Budget budget;
  SelectBudgetEvent(this.budget);
}

class ChangeFeatureSelectionEvent extends BudgetsEvent{
  final int index;
  ChangeFeatureSelectionEvent({
    required this.index
  });
}

class UpdateFeatureEvent extends BudgetsEvent{
  final int index;
  final FeatureState newState;
  UpdateFeatureEvent({
    required this.index, 
    required this.newState
  });
}

class EndBudgetUpdating extends BudgetsEvent{
  
}

class LoadCdpsEvent extends BudgetsEvent{

}

class UpdateCdpsEvent extends BudgetsEvent{

}