import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/components/custom_suffix_icon.dart';
import 'package:getug/components/default_button.dart';
import 'package:getug/components/formerror.dart';
import 'package:getug/constants.dart';
import 'package:getug/models/login/password_forgot.dart';
import 'package:getug/screens/forgot_password/components/forgot_otp.dart';
import 'package:getug/size_config.dart';
import 'dart:convert' as convert;

class Body extends StatelessWidget {
  const Body({super.key});

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
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter yout email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.1,
              ),
              ForgotPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String? otp;
  final TextEditingController emailcontroller = TextEditingController();
  late String email;
  late int userid;

  Future<Forgot_password> forgotPassword(
      {required String type, required String email}) async {
    Map<String, String> data = {"type": "$type", "email": "$email"};
    Forgot_password? forgot = Forgot_password();
    var response = await postJson("/api/forgetPasswordCheckUser", data);
    if (response.statusCode == 200) {
      print(response);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var msg = jsonResponse['user'];
      jsonResponse['data'] = "";
      //  print(msg);
      /* // otp = jsonResponse['otp'];
      //print(otp);*/
      if (msg is String) {
        jsonResponse['user'] = {"msg": msg};
      } else if (msg is Map<String, dynamic>) {
        jsonResponse['user'] = msg;
      } /*  else {
        msg = "";
        jsonResponse['user'] = {
          "userName": "anusha",
          "mobileNumber": null,
          "email": "anushaunni.c@gmail.com",
          "photo": "",
          "firstName": null,
          "lastName": null,
          "description": null,
          "alternateNumber": null,
          "userId": 123,
          "registerPlatformId": 1
        };
      }*/
      print(jsonResponse);
      var itemCount = jsonResponse['user'];
      //
      print('Number of books about http: $jsonResponse}.');
      forgot = Forgot_password.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      jsonResponse['user'] = {};
      forgot = Forgot_password.fromJson(jsonResponse);
      print("er :$jsonResponse");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return forgot!;
  }

  List<String> errors = [];
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailcontroller,
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
                Forgot_password p = await forgotPassword(
                    type: 'Email', email: emailcontroller.text);

                print(p.user?['email']);

                print(p.user!["userId"]);

                print(p.otp!);

                if (p.otp.toString().length >= 0) {
                  Navigator.pushNamed(
                      context, ForgotPasswordOTPVerify.routeName, arguments: {
                    "email": emailcontroller.text,
                    "userid": p.user!["userId"],
                    "otp": p.otp!
                  });
                  // print(email);
                  // print(otp);
                  // print(userid);
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
