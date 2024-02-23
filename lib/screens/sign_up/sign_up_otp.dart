import 'package:flutter/material.dart';

import 'package:getug/screens/sign_up/components/otp/body.dart';

int? otpvalue = 0;
int? otp;
String? data;
late Map<String, dynamic> args;

class SignUpOTPVerify extends StatelessWidget {
  static String routeName = '/sign_up_otp';
  const SignUpOTPVerify({super.key});

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//    otpvalue = otp;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        // title: Text('Sign Up ${args['otp']!}'),
      ),
      body: Body(),
    );
  }
}
