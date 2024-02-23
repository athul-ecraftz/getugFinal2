import 'package:flutter/material.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/products/post.dart';
import 'package:getug/screens/products/product_details.dart';
import 'package:getug/screens/products/update_post.dart';
import 'package:http/http.dart';

class MypostEdit extends StatefulWidget {
  static const String routeName = 'MypostEdit';

  @override
  State<MypostEdit> createState() => _MypostEditState();
}

class _MypostEditState extends State<MypostEdit> {
  @override
  Widget build(BuildContext context) {
    // Get the arguments passed to the route
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Extract the productId from the arguments
    final String productId = args['productId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post $productId'),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'Editing Post with productId: $productId',
      //         style: TextStyle(fontSize: 20),
      //       ),
      //       // Add your editing widgets here
      //     ],
      //   ),
      // ),
      body: UpdatePost(productId: productId),
    );
  }
}
