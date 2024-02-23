import 'package:flutter/material.dart';
import 'package:getug/screens/forgot_password/components/body.dart';

// late int? userid;

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = '/forgot_password';
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // userid = ModalRoute.of(context)!.settings.arguments as int;
    // print(userid);
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Passworrd"),
      ),
      body: Body(),
    );
  }
}
