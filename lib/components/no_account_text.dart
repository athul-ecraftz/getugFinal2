import 'package:flutter/material.dart';
import 'package:getug/constants.dart';
import 'package:getug/screens/sign_up/sign_up_screen.dart';
import 'package:getug/size_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    super.key,
  });

  Future<void> handleSignOut() async {
    print('Logout clicked');
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signOut();
      print(result);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(14),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignUpScreen.routeName);
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.w800,
              color: cPrimaryColor,
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     handleSignOut();
        //   },
        //   child: Text(
        //     "Logout",
        //     style: TextStyle(
        //       fontSize: getProportionateScreenWidth(14),
        //       fontWeight: FontWeight.w800,
        //       color: cPrimaryColor,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
