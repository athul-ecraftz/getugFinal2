import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/components/custom_suffix_icon.dart';
import 'package:getug/components/default_button.dart';
import 'package:getug/components/formerror.dart';
import 'package:getug/constants.dart';
import 'package:getug/models/signup_with_email/signup_with_email.dart';
import 'package:getug/screens/sign_up/sign_up_otp.dart';
import 'package:getug/size_config.dart';
import 'dart:convert' as convert;

class SignUpEmail extends StatelessWidget {
  SignUpEmail({super.key});

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
                "Register Here",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please enter your email and we will send \nyou an OTP to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.1,
              ),
              SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  late String email;

  Future<signup_with_email> register_withemail({required String email}) async {
    Map<String, String> data = {"email": "$email"};

    signup_with_email? Continue;

    var response = await postJson("/api/registeruserbyemail", data);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var msg = jsonResponse['data'];
      if (msg is String) {
        jsonResponse['data'] = "0";
      } else {
        jsonResponse['data'] = msg.toString();
      }
      print("New= $jsonResponse");

      //var itemCount = jsonResponse['data'];
      Continue = signup_with_email.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      // var itemCount = jsonResponse['data'];
      // Continue = signup_with_email.fromJson(jsonResponse);
      var msg = jsonResponse['data'];

      // if (msg is String) {
      //   jsonResponse['data'] = "0";
      // } else {
      //   jsonResponse['data'] = msg as String;
      // }
      // jsonResponse['otp'] = 0;
      //jsonResponse['data'] = msg;
      Continue = signup_with_email.fromJson(jsonResponse);
      print(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return Continue!;
  }

  List<String> errors = [];
  // late String email;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            onSaved: (newValue) => email = newValue!,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(cEmailNullError)) {
                setState(() {
                  errors.remove(cEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(cInvalidEmailError)) {
                setState(() {
                  errors.remove(cInvalidEmailError);
                });
              }
              return null;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(cEmailNullError)) {
                setState(() {
                  errors.add(cEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(cInvalidEmailError)) {
                setState(() {
                  errors.add(cInvalidEmailError);
                });
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email id",
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
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                signup_with_email s =
                    await register_withemail(email: emailController.text);
                print(s.otp);
                if (s.otp! > 0) {
                  Navigator.pushNamed(context, SignUpOTPVerify.routeName,
                      arguments: {
                        "email": emailController.text,
                        "otp": s.otp,
                        "data": s.data
                      });
                }
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
