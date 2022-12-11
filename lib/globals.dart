// ignore_for_file: prefer_const_constructors

import 'package:siex/features/authentication/presentation/page/login_page.dart';
import 'package:siex/features/cdps/presentation/cdps_page.dart';
import 'package:siex/features/home/presentation/home_page.dart';
import 'package:siex/features/records/presentation/records_page.dart';
import 'features/init/presentation/page/init_page.dart';

class NavigationRoutes{
  static const init = 'init';
  static const authentication = 'authentication';
  static const home = 'home';
  static const cdps = 'cdps';
  static const records = 'records';
}

final routes = {
  NavigationRoutes.init: (_) => InitPage(),
  NavigationRoutes.authentication: (_) => LoginPage(),
  NavigationRoutes.home: (_) => const HomePage(),
  NavigationRoutes.cdps: (_) => CdpsPage(),
  NavigationRoutes.records: (_) => RecordsPage()
};