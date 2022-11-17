import 'package:http/http.dart' as http;
import 'package:siex/core/external/remote_data_source.dart';
import 'package:siex/features/budgets/data/budgets_remote_data_source.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/domain/entities/cdps_group.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import 'package:siex/features/budgets/external/budgets_adapter.dart';

class BudgetsRemoteDataSourceImpl extends RemoteDataSource implements BudgetsRemoteDataSource{
  static const baseCdpsUrl = 'presupuesto/cdps';

  final http.Client client;
  final BudgetsAdapter adapter;
  BudgetsRemoteDataSourceImpl({
    required this.client, 
    required this.adapter
  });

  @override
  Future<List<Budget>> getBudgets()async{
    // TODO: implement getBudgets
    throw UnimplementedError();
  }

  @override
  Future<void> updateBudget(Budget budget)async{
    // TODO: implement updateBudget
    throw UnimplementedError();
  }

  @override
  Future<List<Feature>> getNewCdps(String accessToken)async{
    final response = await _getCdps(accessToken);
    return adapter.getNewCdpsFromStringBody(response.body, 'new');
  }
  
  @override
  Future<void> updateCdps(List<Feature> cdps, String accessToken)async{
    // TODO: implement updateCdps
    throw UnimplementedError();
  }
  
  @override
  Future<List<Feature>> getOldCdps(String accessToken)async{
    final response = await _getCdps(accessToken);
    return adapter.getNewCdpsFromStringBody(response.body, 'old');
  }

  Future<http.Response> _getCdps(String accessToken)async{
    return await super.executeGeneralService(()async{
      return await client.get(
        super.getUri(RemoteDataSource.baseApiUncodedPath + baseCdpsUrl),
        headers: super.createAuthorizationJsonHeaders(accessToken)
      );
    });
  }

  @override
  Future<CdpsGroup> getCdps(String accessToken)async{
    final response = await super.executeGeneralService(()async{
      return await client.get(
        super.getUri(RemoteDataSource.baseApiUncodedPath + baseCdpsUrl),
        headers: super.createAuthorizationJsonHeaders(accessToken)
      );
    });
    return adapter.getCdpsGroupFromStringBody(response.body);
  }
}