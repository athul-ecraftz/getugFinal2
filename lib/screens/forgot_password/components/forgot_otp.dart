import 'package:flutter/material.dart';

import 'package:getug/screens/forgot_password/components/otp/body.dart';

late int? otpvalue;
late String? emailValue;
late int? userid;
// late Map<String, dynamic> args;
late Map<String, dynamic> args;

class ForgotPasswordOTPVerify extends StatelessWidget {
  static String routeName = '/forgot_password_otp';
  ForgotPasswordOTPVerify({
    super.key,
  });
  int? otp;
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //  otp = ModalRoute.of(context)!.settings.arguments as int;
    otpvalue = args['otp'];
    emailValue = args['email'];
    userid = args['userid'];

    return Scaffold(
      appBar: AppBar(
        // title: Text('Forgot Passworrd $otp'),
        title: Text('Forgot Password'),
      ),
      body: Body(),
    );
  }
}
