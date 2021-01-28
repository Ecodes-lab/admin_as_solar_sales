import 'package:admin_as_solar_sales/helpers/style.dart';
import 'package:admin_as_solar_sales/widgets/loading.dart';
import 'package:flutter/material.dart';
// import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Loading(),
            ],
          ),
        ],
      ),
    );
  }
}
