import 'package:flutter/material.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/products/post.dart';
import 'package:http/http.dart';

class ProductPost extends StatefulWidget {
  static String routeName = '/ ProductPost';
  const ProductPost({super.key});

  @override
  State<ProductPost> createState() => _ProductPostState();
}

class _ProductPostState extends State<ProductPost> {
  // String dropdownValue = 'Item 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text('Post Your Add'),
            ),
            Spacer(),
          ],
        ),
      ),
      body: PostPage(),
    );
  }
}
