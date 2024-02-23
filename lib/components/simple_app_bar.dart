import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget {
  const SimpleAppBar({super.key, required this.text});
  final String text;
  // final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(text),
    );
  }
}
