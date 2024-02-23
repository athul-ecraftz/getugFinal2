import 'package:flutter/material.dart';

const cPrimaryColor = Color(0xFF0239A2);
const cPrimaryLightColor = Color(0xFF2067D2);
const cPrimaryGradientColor = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff2067d2),
    Color(0xff0239a2),
  ],
);
const cBackgroundGradientColor = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff00ffffff),
    Color(0xffd6e7ff),
    Color(0xffd6e7ff),
  ],
);
const apiKey = "";
const apiBaseLink = "devapi.get-ug.com";
const apiProtocol = "https";
const apiBaseFolder = "api";

const cSecondaryColor = Color(0xFF0239A2);
const cTextColor = Color(0xFF555555);
const cAnimationDuration = Duration(microseconds: 200);

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String cEmailNullError = "Please Enter your email id";
const String cInvalidEmailError = "Please Enter valid email id";
const String cPasswordNullError = "Please Enter your password";
const String cShortPasswordError = "Password is too short";
const String cMatchPasswordError = "Password don't match";
const String cMatchOTPError = "OTP doesn't match";
const String cOTPNullError = "Please Enter OTP";
const String cUsernameNullError = "Please Enter Username";
