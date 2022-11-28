import 'package:flutter/material.dart';
import 'package:siex/features/init/presentation/page/init_page.dart';
import './injection_container.dart' as ic;
import './globals.dart' as globals;
Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
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
      routes: globals.routes,
      home: InitPage()
    );
  }
}