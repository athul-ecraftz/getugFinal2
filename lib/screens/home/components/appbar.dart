import 'package:flutter/material.dart';

class appBarHome extends AppBar {
  appBarHome({
    Key? key,
    required Widget title,
    List<Widget>? actions,
  }) : super(
          key: key,
          title: title,
          actions: actions,
        );
}
