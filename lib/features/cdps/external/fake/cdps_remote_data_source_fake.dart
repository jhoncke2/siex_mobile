import 'dart:io';
import 'dart:async';
import 'package:siex/features/cdps/data/cdps_remote_data_source.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';
import '../../../../core/domain/exceptions.dart';
import '../../../../core/utils/http_responses_manager.dart';
import '../../../../core/utils/path_provider.dart';

class CdpsRemoteDataSourceFake implements CdpsRemoteDataSource{
  static const _examplePdfUrl = 'www.africau.edu/images/default/sample.pdf';
  final List<Feature> newCdps = [
    Feature(id: 100, name: '2.1.2.001', state: null, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 101, name: '2.1.2.002', state: null, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 102, name: '2.1.2.003', state: null, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 103, name: '2.1.2.004', state: null, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 104, name: '2.1.2.005', state: null, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 105, name: '2.1.2.006', state: null, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 106, name: '2.1.2.007', state: null, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 107, name: '2.1.2.008', state: null, date: DateTime.now(), price: 2000000, pdfUrl: ''),
    Feature(id: 108, name: '2.1.2.009', state: null, date: DateTime.now(), price: 2000000, pdfUrl: '')
  ];
  final List<Feature> oldCdps = [
    Feature(id: 1000, name: '2.1.2.010', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1001, name: '2.1.2.020', state: FeatureState.Denied, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1002, name: '2.1.2.030', state: FeatureState.Denied, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1003, name: '2.1.2.040', state: FeatureState.Returned, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1004, name: '2.1.2.050', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1005, name: '2.1.2.060', state: FeatureState.Denied, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1006, name: '2.1.2.070', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1007, name: '2.1.2.080', state: FeatureState.Denied, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1008, name: '2.1.2.090', state: FeatureState.Returned, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1009, name: '2.1.2.100', state: FeatureState.Denied, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1010, name: '2.1.2.110', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1011, name: '2.1.2.120', state: FeatureState.Denied, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1012, name: '2.1.2.130', state: FeatureState.Returned, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1013, name: '2.1.2.140', state: null, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1014, name: '2.1.2.150', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1015, name: '2.1.2.160', state: FeatureState.Denied, date: DateTime.now(), price: 2000000, pdfUrl: _examplePdfUrl),
    Feature(id: 1016, name: '2.1.2.170', state: FeatureState.Returned, date: DateTime.now(), price: 2000000, pdfUrl: ''),
    Feature(id: 1017, name: '2.1.2.180', state: FeatureState.Permitted, date: DateTime.now(), price: 2000000, pdfUrl: '')
  ];
  
  final PathProvider pathProvider;
  final HttpResponsesManager httpResponsesManager;
  CdpsRemoteDataSourceFake({
    required this.pathProvider, 
    required this.httpResponsesManager
  });
  
  @override
  Future<List<Feature>> getNewCdps(String accessToken)async{
    return newCdps;
  }
  
  @override
  Future<void> updateCdps(List<Feature> cdps, String accessToken)async{
    await Future.delayed(const Duration(milliseconds: 1750));
    newCdps.removeWhere((_) => true);
    oldCdps.addAll(
      cdps.where((cdp) => cdp.state == null)
    );
  }
  
  @override
  Future<List<Feature>> getOldCdps(String accesToken)async{
    return oldCdps;
  }

  @override
  Future<CdpsGroup> getCdps(String accessToken)async{
    return CdpsGroup(
      newCdps: newCdps, 
      oldCdps: oldCdps
    );
  }

  @override
  Future<File> getFeaturePdf(Feature feature, String accessToken)async{
    try{
      Completer<File> completer = Completer();
      final url = _examplePdfUrl
          .replaceAll(RegExp('http://'), '')
          .replaceAll('\\', '');
      final urlParts = url.split('/');
      var request = await HttpClient().getUrl(
        Uri.http(urlParts[0], urlParts.sublist(1, urlParts.length).join('/'))
      );
      final dirPath = await pathProvider.generatePath();
      final response = await request.close();
      final bytes = await httpResponsesManager.getBytesFromResponse(response);
      final date = DateTime.now();
      final pdf = File('$dirPath/pdf_${date.year}${date.month}${date.day}${date.hour}${date.second}${date.millisecond}');
      await pdf.writeAsBytes(bytes, flush: true);
      completer.complete(pdf);
      return pdf;
    }catch(err, stackTrace){
      print('************************* pdf error *********************');
      print(err);
      print(stackTrace);
      throw const ServerException(type: ServerExceptionType.NORMAL);
    }
  }
}