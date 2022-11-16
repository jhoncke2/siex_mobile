import 'package:siex/features/authentication/presentation/page/login_page.dart';
import 'package:siex/features/budgets/presentation/budgets_page.dart';
import 'features/init/presentation/page/init_page.dart';

class NavigationRoutes{
  static const init = 'init';
  static const authentication = 'authentication';
  static const budgets = 'home';
}

final routes = {
  NavigationRoutes.init: (_) => InitPage(),
  NavigationRoutes.authentication: (_) => LoginPage(),
  NavigationRoutes.budgets: (_) => BudgetsPage()
};