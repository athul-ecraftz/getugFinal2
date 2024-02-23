import 'package:flutter/material.dart';

import 'package:getug/screens/sign_up/components/final_body.dart';

late Map<String, dynamic>? emailVal;

class SignUpFinal extends StatelessWidget {
  static String routeName = '/sign_up_final';
  const SignUpFinal({super.key});

  @override
  Widget build(BuildContext context) {
    emailVal =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: FinalBody(),
    );
  }
}
