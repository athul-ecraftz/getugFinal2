import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/components/custom_suffix_icon.dart';
import 'package:getug/components/default_button.dart';
import 'package:getug/components/formerror.dart';
import 'package:getug/constants.dart';
import 'package:getug/models/regby_email_verifyotp/registerby_email_verifyotp.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/sign_in/sign_in_screen.dart';
import 'package:getug/size_config.dart';
import 'package:getug/screens/sign_up/components/sign_up_final.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> errors = [];
  final _emailController = TextEditingController(text: emailVal!['email']);
  final userid = emailVal!['userid'];
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  late String email;
  late String username;
  late dynamic password;
  late dynamic confirmpassword;
  bool remember = false;

  Future<registerby_email_verifyotp> register_byemail_verifyotp(
      {required int userid,
      required String username,
      required dynamic password,
      required dynamic confirmpassword,
      required String email}) async {
    Map<String, String> data = {
      "userid": "$userid",
      "username": "$username",
      "password": "$password",
      "confirmpassword": "$confirmpassword",
      "email": "$email"
    };

    registerby_email_verifyotp? Submit;
    var response = await postJson("/api/registerbyemailverifyotp", data);
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

      var itemCount = jsonResponse['data'];
      //  jsonResponse['user'] = null;
      Submit = registerby_email_verifyotp.fromJson(jsonResponse);
      print('Number of books about http: $jsonResponse}.');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);

      jsonResponse['user'] = null;
      var itemCount = jsonResponse['user'];

      print(itemCount);
      Submit = registerby_email_verifyotp.fromJson(jsonResponse);
      print(Submit);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return Submit!;
  }

  Future<void> saveRedisteredData(String email, String userid) async {
    final prefs = await SharedPreferences.getInstance();
    final email = _emailController.text;
    // userid:
    // int.parse(userid).toString();
    // print(email);
    // print(userid);

    final bool isLoggedIn = false;

    await prefs.setString('email', email);
    await prefs.setString('userid', userid);
    await prefs.setBool('isLoggedIn', true);

    // print(prefs.getString('email'));
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
          buildUsernameFormField(),
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
                registerby_email_verifyotp r = await register_byemail_verifyotp(
                    userid: int.parse(userid),
                    username: usernameController.text,
                    password: passwordController.text,
                    confirmpassword: confirmpasswordController.text,
                    email: _emailController.text);
                if (r != null && r.user!['email'].toString() != null) {
                  saveRedisteredData(email, userid);
                  Map<String, dynamic>? users = r.user;
                  String em = users!['email'].toString();
                  print(r.user!['email'].toString());
                  print(r.user!['username'].toString());
                  print(r.user!['userid'].toString());
                  Navigator.pushNamed(context, SignInScreen.routeName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User Name Already Exist")));
                }
                // print(r.user);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
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
      controller: confirmpasswordController,
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
        } else if (value != passwordController.text) {
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
      controller: _emailController,
      readOnly: true,
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

  TextFormField buildUsernameFormField() {
    return TextFormField(
      controller: usernameController,
      onSaved: (newValue) => email = newValue!,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errors.remove(cUsernameNullError);
          });
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          setState(() {
            errors.add(cUsernameNullError);
          });
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Username",
        hintText: "Enter username",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.person,
        ),
      ),
    );
  }
}
