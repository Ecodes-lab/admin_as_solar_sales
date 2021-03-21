import 'package:admin_as_solar_sales/providers/user.dart';
import 'package:admin_as_solar_sales/screens/confirm_email.dart';
import 'package:admin_as_solar_sales/screens/login.dart';
import 'package:admin_as_solar_sales/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:admin_as_solar_sales/providers/app_states.dart';
import 'package:admin_as_solar_sales/providers/products_provider.dart';
import 'package:admin_as_solar_sales/screens/admin.dart';
import 'package:admin_as_solar_sales/screens/dashboard.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: UserProvider.initialize()),
      ChangeNotifierProvider.value(value: ProductProvider.initialize()),
      ChangeNotifierProvider.value(value: AppState()),

    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreensController(),
    ),
  ));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return Dashboard();
      case Status.ConfirmEmail:
        return ConfirmEmail();
      default: return Login();
    }
  }
}