import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:siex/core/domain/entities/time_state.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';
import 'package:siex/features/cdps/external/cdps_adapter.dart';

late CdpsAdapter budgetsAdapter;

void main(){
  setUp((){
    budgetsAdapter = CdpsAdapter();
  });

  group('get cdps group from json body', _testGetCdpsGroupFromJsonBodyGroup);
  group('get cdps body from cdps', _testGetCdpsBodyFromCdpsGroup);
}

void _testGetCdpsGroupFromJsonBodyGroup(){
  late String tJsonBody;
  late CdpsGroup tCdpsGroup;
  
  test('should return the expected result with json body 1', ()async{
    const tJson = {
      'data': {
        'old': [],
        'new': []
      }
    };
    tJsonBody = jsonEncode(tJson);
    tCdpsGroup = const CdpsGroup(
      oldCdps: [],
      newCdps: []
    );
    final result = budgetsAdapter.getCdpsGroupFromStringBody(tJsonBody);
    expect(result, tCdpsGroup);
  });

  test('should return the expected result with json body 2', ()async{
    const tJson = {
      'data': {
        'old': [
          {
              "name": "name1",
              "valor": 100000,
              "fecha": "2022-10-06",
              "id": 1,
              "status": "1"
          },
          {
              "name": "name2",
              "valor": 200000,
              "fecha": "2022-10-06",
              "id": 2,
              "status": "2"
          },
          {
              "name": "name3",
              "valor": 300000,
              "fecha": "2022-10-06",
              "id": 3,
              "status": "3"
          }
        ],
        'new': [
          {
              "name": "name4",
              "valor": 400000,
              "fecha": "2022-10-06",
              "id": 4,
              "status": "0"
          },
          {
              "name": "name5",
              "valor": 500000,
              "fecha": "2022-10-06",
              "id": 5
          }
        ]
      }
    };
    tJsonBody = jsonEncode(tJson);
    tCdpsGroup = CdpsGroup(
      oldCdps: [
        Cdp(
          id: 1, 
          name: 'name1', 
          state: TimeState.denied, 
          date: DateTime(2022, 10, 06), 
          price: 100000,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 2, 
          name: 'name2', 
          state: TimeState.returned, 
          date: DateTime(2022, 10, 06), 
          price: 200000,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 3, 
          name: 'name3', 
          state: TimeState.permitted, 
          date: DateTime(2022, 10, 06), 
          price: 300000,
          pdfUrl: 'pdf_url'
        )
      ],
      newCdps: [
        Cdp(
          id: 4, 
          name: 'name4', 
          state: null, 
          date: DateTime(2022, 10, 06), 
          price: 400000,
          pdfUrl: 'pdf_url'
        ),
        Cdp(
          id: 5, 
          name: 'name5', 
          state: null, 
          date: DateTime(2022, 10, 06), 
          price: 500000,
          pdfUrl: 'pdf_url'
        )
      ]
    );
    final result = budgetsAdapter.getCdpsGroupFromStringBody(tJsonBody);
    expect(result, tCdpsGroup);
  });
}

void _testGetCdpsBodyFromCdpsGroup(){
  late List<Cdp> tCdps;
  late String tBody;

  test('should return the expected result with empty cdps list', ()async{
    tCdps = [];
    const tJsonBody = {
      'cdps': []
    };
    tBody = jsonEncode(tJsonBody);
    final result = budgetsAdapter.getCdpsBodyFromCdps(tCdps);
    expect(result, tBody);
  });

  test('should return the expected result with noEmpty cdps list 1', ()async{
    const tYear = 2020;
    const tMonth = 10;
    const tDay = 20;
    tCdps = [
      Cdp(
        id: 1,
        name: 'name_1',
        state: TimeState.denied,
        date: DateTime(tYear, tMonth, tDay),
        price: 10000,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 2,
        name: 'name_2',
        state: TimeState.returned,
        date: DateTime(tYear, tMonth, tDay),
        price: 20000,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 3,
        name: 'name_3',
        state: TimeState.permitted,
        date: DateTime(tYear, tMonth, tDay),
        price: 30000,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 4,
        name: 'name_4',
        state: null,
        date: DateTime(tYear, tMonth, tDay),
        price: 40000,
        pdfUrl: 'pdf_url'
      )
    ];
    const tJsonBody = {
      'cdps': [
        [1, "1"],
        [2, "2"],
        [3, "3"],
        [4, "0"]
      ]
    };
    tBody = jsonEncode(tJsonBody);
    final result = budgetsAdapter.getCdpsBodyFromCdps(tCdps);
    expect(result, tBody);
  });

  test('should return the expected result with noEmpty cdps list 2', ()async{
    const tYear = 2020;
    const tMonth = 10;
    const tDay = 20;
    tCdps = [
      Cdp(
        id: 1,
        name: 'name_1',
        state: null,
        date: DateTime(tYear, tMonth, tDay),
        price: 10000,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 2,
        name: 'name_2',
        state: TimeState.denied,
        date: DateTime(tYear, tMonth, tDay),
        price: 20000,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 3,
        name: 'name_3',
        state: TimeState.permitted,
        date: DateTime(tYear, tMonth, tDay),
        price: 30000,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 4,
        name: 'name_4',
        state: null,
        date: DateTime(tYear, tMonth, tDay),
        price: 40000,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 5,
        name: 'name_5',
        state: TimeState.returned,
        date: DateTime(tYear, tMonth, tDay),
        price: 50000,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 6,
        name: 'name_6',
        state: null,
        date: DateTime(tYear, tMonth, tDay),
        price: 60000,
        pdfUrl: 'pdf_url'
      ),
      Cdp(
        id: 7,
        name: 'name_7',
        state: TimeState.permitted,
        date: DateTime(tYear, tMonth, tDay),
        price: 70000,
        pdfUrl: 'pdf_url'
      )
    ];
    const tJsonBody = {
      'cdps': [
        [1, "0"],
        [2, "1"],
        [3, "3"],
        [4, "0"],
        [5, "2"],
        [6, "0"],
        [7, "3"]
      ]
    };
    tBody = jsonEncode(tJsonBody);
    final result = budgetsAdapter.getCdpsBodyFromCdps(tCdps);
    expect(result, tBody);
  });
}