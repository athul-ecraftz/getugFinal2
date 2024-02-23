import 'package:flutter/material.dart';
import 'package:getug/screens/sign_up/components/sign_up_email.dart';
import 'package:getug/size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

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
                'Welcome Back',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(28),
                ),
              ),
              const Text(
                "Sign up with your email",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.08,
              ),
              SignUpEmail(),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.08,
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              // NoAccountText()
            ]),
          ),
        ),
      ),
    );
  }
}
