import 'dart:convert';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';

import '../../../core/domain/entities/time_state.dart';

class CdpsAdapter{

  CdpsGroup getCdpsGroupFromStringBody(String body){
    final jsonBody = jsonDecode(body);
    final group = CdpsGroup(
      newCdps: _getCdpsFromJsonList(jsonBody['data']['new'].cast<Map<String, dynamic>>()), 
      oldCdps: _getCdpsFromJsonList(jsonBody['data']['old'].cast<Map<String, dynamic>>())
    );
    return group;
  }

  List<Cdp> _getCdpsFromJsonList(List<Map<String, dynamic>> jsonList) => jsonList.map(
    (json) => _getCdpFromJson(json)
  ).toList();

  List<Cdp> getOldCdpsFromStringBody(String body, String type){
    final jsonBody = jsonDecode(body);
    return (jsonBody['old'] as List).map(
      (json) => _getCdpFromJson(json)
    ).toList();
  }

  List<Cdp> getNewCdpsFromStringBody(String body, String type){
    final jsonBody = jsonDecode(body);
    return (jsonBody['new'] as List).map(
      (json) => _getCdpFromJson(json)
    ).toList();
  }

  Cdp _getCdpFromJson(Map<String, dynamic> json){
    final dateParts = (json['fecha'] as String)
        .split('-')
        .map<int>(
          (p) => int.parse(p)
        ).toList();
    return Cdp(
      id: json['id'],
      name: json['name'],
      state: _getFeatureStateFromStatus(json['status']),
      price: double.parse(json['valor'].toString()),
      date: DateTime(dateParts[0], dateParts[1], dateParts[2]),
      pdfUrl: json['pdf']??''
    );
  }

  TimeState? _getFeatureStateFromStatus(dynamic status){
    if(status == null){
      return null;
    }else{
      final statusNumber = int.parse(status as String);
      if(statusNumber == 0){
        return null;
      }else if(statusNumber == 1){
        return TimeState.denied;
      }else if(statusNumber == 2){
        return TimeState.returned;
      }else{
        return TimeState.permitted;
      }
    }
  }

 String getCdpsBodyFromCdps(List<Cdp> cdps){
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

  String _getStatusNumberFromFeatureState(TimeState? state) => 
      (state == null)? "0" :
      (state == TimeState.denied)? "1" :
      (state == TimeState.returned)? "2" :
      "3";

  List<Cdp> getFeaturesFromMap(List<Map<String, dynamic>> jsonList) => jsonList.map(
    (json) => getFeatureFromJson(json) 
  ).toList();
  
  Cdp getFeatureFromJson(Map<String, dynamic> json){
    final dateParts = (json['date'] as String)
        .split('-')
        .map<int>(
          (p) => int.parse(p)
        ).toList();
    return Cdp(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      price: json['price'],
      pdfUrl: json['pdf_url'],
      date: DateTime(dateParts[0], dateParts[1], dateParts[2])
    );
  }
}