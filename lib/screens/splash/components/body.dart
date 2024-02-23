import 'package:flutter/material.dart';
import 'package:getug/components/sign_button.dart';
import 'package:getug/constants.dart';
import 'package:getug/screens/sign_in/sign_in_screen.dart';
import 'package:getug/screens/sign_up/sign_up_screen.dart';
import 'package:getug/size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: const BoxDecoration(
        gradient: cBackgroundGradientColor,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 36.0, top: 60.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/getug_logo.png',
                  width: 166,
                  height: 59,
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(90, -35),
            child: Container(
              child: Image.asset(
                'assets/images/splash_pic.png',
                width: getProportionateScreenWidth(200),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, -50),
            child: Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Text(
                "Get Your \nProducts &\nSell Your Product",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(45),
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.1,
                  fontFamily: 'HelveticaNeue-Light',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, top: 0.0, right: 50.0),
            child: Text(
              'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.2,
                fontFamily: 'HelveticaNeue-Light',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 36.0, top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SignButton(
                  text: "LOGIN",
                  press: () {
                    Navigator.pushNamed(context, SignInScreen.routeName);
                  },
                  gradient: const LinearGradient(
                    colors: [Color(0xff014040), Color(0xff014040)],
                  ),
                ),
                SignButton(
                  text: "REGISTER",
                  press: () {
                    Navigator.pushNamed(context, SignUpScreen.routeName);
                  },
                  gradient: cPrimaryGradientColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Container SignUpButton() {
  //   return Container(
  //     height: 60.0,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(30),
  //         gradient: cPrimaryGradientColor),
  //     child: ElevatedButton(
  //       onPressed: () {
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //     builder: (context) => const RegisterScreen(),
  //         //   ),
  //         // );
  //       },
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.transparent,
  //           shadowColor: Colors.transparent),
  //       child: const Padding(
  //         padding:
  //             EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
  //         child: Text(
  //           "REGISTER",
  //           style: TextStyle(
  //             fontSize: 17,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.white,
  //             height: 1.3,
  //             fontFamily: 'HelveticaNeue-Light',
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Container SignInButton(BuildContext ctx) {
  //   return Container(
  //     height: 60.0,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(30),
  //         gradient: const LinearGradient(
  //             colors: [Color(0xff014040), Color(0xff000d0d)])),
  //     child: ElevatedButton(
  //       onPressed: () {
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //     builder: (context) => const SigninScreen(),
  //         //   ),
  //         // );
  //         Navigator.pushNamed(ctx, SignInScreen.routeName);
  //       },
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.transparent,
  //           shadowColor: Colors.transparent),
  //       child: const Padding(
  //         padding:
  //             EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
  //         child: Text(
  //           "LOGIN",
  //           style: TextStyle(
  //             fontSize: 17,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.white,
  //             height: 1.3,
  //             fontFamily: 'HelveticaNeue-Light',
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
