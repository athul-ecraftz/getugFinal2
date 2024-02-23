import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getug/size_config.dart';

class CustomSuffixIcon extends StatelessWidget {
  const CustomSuffixIcon({
    super.key,
    required this.svgicon,
  });
  final String svgicon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(15),
        getProportionateScreenWidth(15),
        getProportionateScreenWidth(15),
      ),
      child: SvgPicture.asset(
        svgicon,
        height: getProportionateScreenHeight(18),
      ),
    );
  }
}
