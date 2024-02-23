import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/components/custom_suffix_icon.dart';
import 'package:getug/components/default_button.dart';
import 'package:getug/components/formerror.dart';
import 'package:getug/constants.dart';
import 'package:getug/models/login/user_login.dart';
import 'package:getug/screens/forgot_password/forgot_password_screen.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class SignForm extends StatefulWidget {
  SignForm({super.key});

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController useridcontroller = TextEditingController();

  final List<String> errors = [];
  late String email;
  late int userid;
  late String firstName;
  late String lastName;
  late int mobileNumber;
  late int alternateNumber;
  late String description;
  late String password;
  late String photo;

  bool remember = false;
  bool isPasswordVisible = false;
  Future<Login> userLogin(
      {required String email, required String password}) async {
    Map<String, String> data = {
      "email": "$email",
      "password": "$password",
      "loginType": "Email"
    };
    Login? user;
    var response = await postJson("/api/userLogin", data);
    if (response.statusCode == 200) {
      // print(response);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['user'];
      user = Login.fromJson(itemCount);
      // print('Number of books about http: $itemCount.');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      jsonResponse['user'] = {};
      user = Login.fromJson(jsonResponse);
      print(user);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return user!;
  }

  Future<void> saveLoginData(
      String userid,
      String email,
      String firstName,
      String lastName,
      String mobileNumber,
      String alternateNumber,
      String photo,
      String description) async {
    final prefs = await SharedPreferences.getInstance();
    final email = emailController.text;
    // final userid = useridcontroller.text;
    // final password = passwordController.text;
    // print(userid);
    // print(email);

    final bool isLoggedIn = false;

    await prefs.setString('email', emailController.text);
    // await prefs.setString('userId', emailController.text);
    // await prefs.setString('password', passwordController.text);
    await prefs.setString('userid', userid);
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('mobileNumber', mobileNumber);
    await prefs.setString('alternateNumber', alternateNumber);
    await prefs.setString('photo', photo);
    await prefs.setString('description', description);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setBool('loginWithGoogle', false);

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
          buildPasswordFormField(),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: cPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value!;
                  });
                },
              ),
              const Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          FormError(errors: errors),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                Login u = await userLogin(
                    email: emailController.text,
                    password: passwordController.text);
                // late int userid;
                if (u != null && u.email != null) {
                  // print(u.email);
                  // print(u.userId);

                  await saveLoginData(
                      u.userId.toString(),
                      u.email.toString(),
                      u.firstName.toString(),
                      u.lastName.toString(),
                      u.mobileNumber.toString(),
                      u.alternateNumber.toString(),
                      u.photo.toString(),
                      u.description.toString());

                  // print(u.toJson());
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName, (Route<dynamic> route) => false);
                  // print('test');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Incorrect Email or Password"),
                    margin: EdgeInsets.all(10.0),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
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
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgicon: 'assets/icons/lock.svg',
        ),
        // IconButton(
        //     onPressed: () {
        //       setState(() {
        //         isPasswordVisible = !isPasswordVisible;
        //       });
        //     },
        //     icon: Icon(isPasswordVisible
        //         ? Icons.visibility
        //         : Icons.visibility_off))
      ),

      // obscureText: !isPasswordVisible,
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
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
      controller: emailController,
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

  // Future<void> saveUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('username', emailController.text);
  //   await prefs.setString('email', passwordController.text);
  // }
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    if (savedEmail != null && savedPassword != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
}
