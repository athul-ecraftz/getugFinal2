import 'package:flutter/material.dart';

import 'package:getug/screens/forgot_password/components/final_body.dart';

late String? emailval;
late Map<String, dynamic> args;

class ForgotPasswordFinal extends StatelessWidget {
  static String routeName = '/forgot_password_final';
  const ForgotPasswordFinal({super.key});

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: FinalBody(),
    );
  }
}
