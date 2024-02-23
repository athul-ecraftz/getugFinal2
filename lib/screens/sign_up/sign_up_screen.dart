import 'package:flutter/material.dart';
import 'package:getug/screens/sign_up/components/sign_up_email.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = '/sign_up';
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SignUpEmail(),
    );
  }
}
