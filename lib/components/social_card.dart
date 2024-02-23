import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:getug/size_config.dart';

class SocialCard extends StatelessWidget {
  SocialCard({super.key, required this.icon, required this.press});
  String icon;
  VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
        ),
        padding: EdgeInsets.all(
          getProportionateScreenWidth(1),
        ),
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(40),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
