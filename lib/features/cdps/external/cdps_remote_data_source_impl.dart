import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:siex/core/external/remote_data_source.dart';
import 'package:siex/core/utils/http_responses_manager.dart';
import 'package:siex/core/utils/path_provider.dart';
import 'package:siex/features/cdps/data/cdps_remote_data_source.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';
import 'package:siex/features/cdps/external/cdps_adapter.dart';
import '../../../core/domain/exceptions.dart';

class CdpsRemoteDataSourceImpl extends RemoteDataSource implements CdpsRemoteDataSource{
  static const baseCdpsUrl = 'presupuesto/cdps';

  final http.Client client;
  final CdpsAdapter adapter;
  final PathProvider pathProvider;
  final HttpResponsesManager httpResponsesManager;
  CdpsRemoteDataSourceImpl({
    required this.client,
    required this.adapter,
    required this.pathProvider,
    required this.httpResponsesManager
  });

  @override
  Future<List<Feature>> getNewCdps(String accessToken)async{
    final response = await _getCdps(accessToken);
    return adapter.getNewCdpsFromStringBody(response.body, 'new');
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

  @override
  Future<void> updateCdps(List<Feature> cdps, String accessToken)async{
    await super.executeGeneralService(()async{
      return await client.post(
        super.getUri('${RemoteDataSource.baseApiUncodedPath}$baseCdpsUrl/update-status'),
        headers: super.createAuthorizationJsonHeaders(accessToken),
        body: adapter.getCdpsBodyFromCdps(cdps)
      );
    });
  }

  @override
  Future<File> getFeaturePdf(Feature feature, String accessToken)async{
    try{
      Completer<File> completer = Completer();
      final url = feature.pdfUrl
          .replaceAll(RegExp('https://'), '')
          .replaceAll(RegExp('http://'), '')
          .replaceAll('\\', '');
      final urlParts = url.split('/');
      var httpRequest = await HttpClient().getUrl(
        Uri.http(urlParts[0], urlParts.sublist(1, urlParts.length).join('/'))
      );
      httpRequest.headers.set('Authorization', 'Bearer $accessToken');
      final dirPath = await pathProvider.generatePath();
      final response = await httpRequest.close();
      final bytes = await httpResponsesManager.getBytesFromResponse(response);
      final date = DateTime.now();
      final pdf = File('$dirPath/pdf_${date.year}${date.month}${date.day}${date.hour}${date.second}${date.millisecond}');
      await pdf.writeAsBytes(bytes, flush: true);
      completer.complete(pdf);
      return pdf;
    }catch(err, stackTrace){
      throw const ServerException(type: ServerExceptionType.NORMAL);
    }
  }
}