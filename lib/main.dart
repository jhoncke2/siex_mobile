import 'package:flutter/material.dart';
import 'package:siex/features/budgets/presentation/budgets_page.dart';
import './injection_container.dart' as ic;
void main() {
  ic.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'vido trial',
      home: BudgetsPage(),
    );
  }
}