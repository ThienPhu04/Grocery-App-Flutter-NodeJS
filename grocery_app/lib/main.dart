import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/pages/dashboard_page.dart';
import 'package:grocery_app/pages/home_page.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:grocery_app/pages/product_details_page.dart';
import 'package:grocery_app/pages/products_page.dart';
import 'package:grocery_app/pages/register_page.dart';
import 'package:grocery_app/utils/shared_service.dart';

Widget _defaultHome = const LoginPage();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await SharedService.isLoggedIn();

  if (_result) {
    _defaultHome = const DashboardPage();
  }
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      routes: <String, WidgetBuilder>{
        '/': (context) => _defaultHome,
        '/register': (BuildContext context) => const RegisterPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/products': (BuildContext context) => const ProductsPage(),
        '/product-details': (BuildContext context) => const ProductDetailsPage()
      },
    );
  }
}
