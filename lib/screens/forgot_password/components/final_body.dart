import 'package:flutter/material.dart';
import 'package:getug/screens/forgot_password/components/passwordform.dart';
import 'package:getug/size_config.dart';

class FinalBody extends StatelessWidget {
  const FinalBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: SizeConfig.screenHeight! * 0.04,
              ),
              Text(
                'New Password',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(28),
                ),
              ),
              const Text(
                "Create your new password",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.08,
              ),
              const PasswordForm(),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.08,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SocialCard(
              //       icon: "assets/icons/google.svg",
              //       press: () {},
              //     ),
              //     // SocialCard(
              //     //   icon: "assets/icons/facebook.svg",
              //     //   press: () {},
              //     // ),
              //     // SocialCard(
              //     //   icon: "assets/icons/twitter.svg",
              //     //   press: () {},
              //     // ),
              //   ],
              // ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              //  NoAccountText()
            ]),
          ),
        ),
      ),
    );
  }
}
