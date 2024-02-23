import 'package:flutter/material.dart';
import 'package:getug/size_config.dart';

class SignButton extends StatelessWidget {
  const SignButton(
      {super.key,
      required this.text,
      required this.press,
      required this.gradient});
  final String text;
  final VoidCallback press;
  final LinearGradient gradient;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(60),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), gradient: gradient),
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: Padding(
          padding:
              EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
              fontFamily: 'HelveticaNeue-Light',
            ),
          ),
        ),
      ),
    );
  }
}
