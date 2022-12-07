import 'dart:convert';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';

class CdpsAdapter{

  CdpsGroup getCdpsGroupFromStringBody(String body){
    final jsonBody = jsonDecode(body);
    final group = CdpsGroup(
      newCdps: _getCdpsFromJsonList(jsonBody['data']['new'].cast<Map<String, dynamic>>()), 
      oldCdps: _getCdpsFromJsonList(jsonBody['data']['old'].cast<Map<String, dynamic>>())
    );
    return group;
  }

  List<Feature> _getCdpsFromJsonList(List<Map<String, dynamic>> jsonList) => jsonList.map(
    (json) => _getCdpFromJson(json)
  ).toList();

  List<Feature> getOldCdpsFromStringBody(String body, String type){
    final jsonBody = jsonDecode(body);
    return (jsonBody['old'] as List).map(
      (json) => _getCdpFromJson(json)
    ).toList();
  }

  List<Feature> getNewCdpsFromStringBody(String body, String type){
    final jsonBody = jsonDecode(body);
    return (jsonBody['new'] as List).map(
      (json) => _getCdpFromJson(json)
    ).toList();
  }

  Feature _getCdpFromJson(Map<String, dynamic> json){
    final dateParts = (json['fecha'] as String)
        .split('-')
        .map<int>(
          (p) => int.parse(p)
        ).toList();
    return Feature(
      id: json['id'],
      name: json['name'],
      state: _getFeatureStateFromStatus(json['status']),
      price: double.parse(json['valor'].toString()),
      date: DateTime(dateParts[0], dateParts[1], dateParts[2]),
      pdfUrl: json['pdf']??''
    );
  }

  FeatureState? _getFeatureStateFromStatus(dynamic status){
    if(status == null){
      return null;
    }else{
      final statusNumber = int.parse(status as String);
      if(statusNumber == 0){
        return null;
      }else if(statusNumber == 1){
        return FeatureState.Denied;
      }else if(statusNumber == 2){
        return FeatureState.Returned;
      }else{
        return FeatureState.Permitted;
      }
    }
  }

 String getCdpsBodyFromCdps(List<Feature> cdps){
    final body = {
      'cdps': cdps.map(
        (cdp) => [
          cdp.id,
          _getStatusNumberFromFeatureState(cdp.state)
        ]
      ).toList()
    };
    return jsonEncode(body);
  }

  String _getStatusNumberFromFeatureState(FeatureState? state) => 
      (state == null)? "0" :
      (state == FeatureState.Denied)? "1" :
      (state == FeatureState.Returned)? "2" :
      "3";

  List<Feature> getFeaturesFromMap(List<Map<String, dynamic>> jsonList) => jsonList.map(
    (json) => getFeatureFromJson(json) 
  ).toList();
  
  Feature getFeatureFromJson(Map<String, dynamic> json){
    final dateParts = (json['date'] as String)
        .split('-')
        .map<int>(
          (p) => int.parse(p)
        ).toList();
    return Feature(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      price: json['price'],
      pdfUrl: json['pdf_url'],
      date: DateTime(dateParts[0], dateParts[1], dateParts[2])
    );
  }
}