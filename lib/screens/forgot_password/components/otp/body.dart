import 'package:flutter/material.dart';

import 'package:getug/components/custom_suffix_icon.dart';
import 'package:getug/components/default_button.dart';
import 'package:getug/components/formerror.dart';
import 'package:getug/constants.dart';
import 'package:getug/screens/forgot_password/components/forgot_otp.dart';
import 'package:getug/screens/forgot_password/components/forgot_password_final.dart';
import 'package:getug/screens/sign_up/components/sign_up_final.dart';
import 'package:getug/size_config.dart';

class Body extends StatelessWidget {
  Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight! * 0.04,
              ),
              Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your OTP",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.1,
              ),
              SignUpFormVerify(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpFormVerify extends StatefulWidget {
  SignUpFormVerify({super.key});

  @override
  State<SignUpFormVerify> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<SignUpFormVerify> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  // final otpController = TextEditingController(text: otpvalue.toString()!);
  final otpController = TextEditingController();
  late String email;
  late int userid;
  late Map<String, dynamic> args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: otpController,
            //  onSaved: (newValue) => email = newValue!,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if ((value.isNotEmpty &&
                  errors.contains(cOTPNullError) &&
                  value.length == 4)) {
                setState(() {
                  errors.remove(cOTPNullError);
                });
              }
              // else if (errors.contains(cMatchOTPError)) {
              //   setState(() {
              //     errors.remove(cMatchOTPError);
              //   });
              // }
              return null;
            },
            validator: (value) {
              if ((value!.isEmpty &&
                  !errors.contains(cEmailNullError) &&
                  value.length != 4)) {
                setState(() {
                  errors.add(cEmailNullError);
                });
              }
              // else if (!errors.contains(cMatchOTPError)) {
              //   setState(() {
              //     errors.add(cMatchOTPError);
              //   });
              // }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "OTP",
              hintText: "Enter your OTP",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSuffixIcon(
                svgicon: 'assets/icons/mail.svg',
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          FormError(errors: errors),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.1,
          ),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // print("otp= $otpvalue");
                if (otpvalue == int.parse(otpController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      content: Text("OTP verification completed")));
                  // Navigator.pushNamed(context, ForgotPasswordFinal.routeName,
                  //     arguments: emailValue!);
                  Navigator.pushNamed(context, ForgotPasswordFinal.routeName,
                      arguments: {
                        "emailval": args['email'],
                        "userid": args['userid']
                      });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                      content:
                          // Text("Invalid OTP $otpvalue ${otpController.text}")));
                          Text("Invalid OTP")));
                }
              } else {
                print('Invalid OTP');
              }
            },
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.1,
          ),
          // NoAccountText(),
        ],
      ),
    );
  }
}
