import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget {
  CommonAppBar({
    super.key,
    required this.text,
    this.suffixIcon,
    this.prefixIcon,
  });
  final String text;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  // final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(text),
    );
  }
}
