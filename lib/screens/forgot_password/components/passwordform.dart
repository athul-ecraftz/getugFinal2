import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/components/custom_suffix_icon.dart';
import 'package:getug/components/default_button.dart';
import 'package:getug/components/formerror.dart';
import 'package:getug/constants.dart';
import 'package:getug/models/login/confirm_password.dart';
import 'package:getug/screens/forgot_password/components/forgot_password_final.dart';
import 'package:getug/screens/sign_in/sign_in_screen.dart';
import 'package:getug/size_config.dart';
import 'dart:convert' as convert;

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key});

  @override
  State<PasswordForm> createState() => _SignFormState();
}

class _SignFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final emailcontroller =
      TextEditingController(text: args['emailval'].toString()!);

  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  late String emailval;
  late dynamic password;
  late int userid;
  late dynamic confirmpassword;
  bool remember = false;

  Future<Confirm_password> confirm_pass({
    required int userid,
    required String password,
  }) async {
    Map<String, String> data = {"userid": "$userid", "password": "$password"};
    Confirm_password? Submit;

    var response = await postJson("/api/updatePassword", data);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("New= $jsonResponse");
      // var msg = jsonResponse['data'];
      // if (msg is String) {
      //  jsonResponse['data'] = "0";

      // } else {
      //   jsonResponse['data'] = msg.toString();
      // }
      // print("New= $jsonResponse");
      // print("$jsonResponse['data']");

      var itemCount = jsonResponse['data'];
      //  jsonResponse['user'] = null;
      Submit = Confirm_password.fromJson(jsonResponse);
      print('Number of books about http: $jsonResponse}.');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);

      // jsonResponse['data'] = null;
      var itemCount = jsonResponse['data'];

      print(itemCount);
      Submit = Confirm_password.fromJson(jsonResponse);
      print(Submit);
    } else {
      print('User Not Found: ${response.statusCode}.');
    }
    return Submit!;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          buildPasswordFormField(),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          buildConfirmPasswordFormField(),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          FormError(errors: errors),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          DefaultButton(
            text: "Submit",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (passwordcontroller.text == confirmpasswordcontroller.text) {
                  Confirm_password c = await confirm_pass(
                    userid: args['userid']!,
                    password: passwordcontroller.text,
                  ) as Confirm_password;
                  // print(c.status);
                  if (c.status == "Success") {
                    Navigator.pushNamed(context, SignInScreen.routeName);
                  }
                }
              } else {}
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordcontroller,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(cEmailNullError)) {
          setState(() {
            errors.remove(cPasswordNullError);
          });
        } else if (value.length >= 8 && errors.contains(cShortPasswordError)) {
          setState(() {
            errors.remove(cShortPasswordError);
          });
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(cPasswordNullError)) {
          setState(() {
            errors.add(cPasswordNullError);
          });
          return "";
        } else if (value.length < 8 && !errors.contains(cShortPasswordError)) {
          setState(() {
            errors.add(cShortPasswordError);
          });
          return "";
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgicon: 'assets/icons/lock.svg',
        ),
      ),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmpasswordcontroller,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(cEmailNullError)) {
          setState(() {
            errors.remove(cPasswordNullError);
          });
        } else if (value.length >= 8 && errors.contains(cShortPasswordError)) {
          setState(() {
            errors.remove(cShortPasswordError);
          });
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(cPasswordNullError)) {
          setState(() {
            errors.add(cPasswordNullError);
          });
          return "";
        } else if (value.length < 8 && !errors.contains(cShortPasswordError)) {
          setState(() {
            errors.add(cShortPasswordError);
          });
          return "";
        } else if (value != passwordcontroller.text) {
          return "Passwords do not match";
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        hintText: "Enter Confirm password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgicon: 'assets/icons/lock.svg',
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailcontroller,
      onSaved: (newValue) => emailval = newValue!,
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
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value) &&
            !errors.contains(cInvalidEmailError)) {
          setState(() {
            errors.add(cInvalidEmailError);
          });
          return "";
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
    );
  }
}
