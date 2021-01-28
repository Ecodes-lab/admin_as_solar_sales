import 'package:admin_as_solar_sales/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmEmail extends StatelessWidget {
  const ConfirmEmail({Key key}) : super(key: key);
  static String id = 'confirm-email';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Center(
              child: Text(
                'An email has just been sent to you, Click the link provided to complete registration',
                style: TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userProvider.signOut();
        },
        child: Icon(Icons.logout),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}