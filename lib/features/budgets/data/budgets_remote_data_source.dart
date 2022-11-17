import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';

import '../domain/entities/budget.dart';

abstract class BudgetsRemoteDataSource{
  Future<List<Budget>> getBudgets();
  Future<void> updateBudget(Budget budget);
  Future<List<Feature>> getNewCdps(String accessToken);
  Future<void> updateCdps(List<Feature> cdps, String accessToken);
  Future<List<Feature>> getOldCdps(String accessToken);
  Future<CdpsGroup> getCdps(String accessToken);
}