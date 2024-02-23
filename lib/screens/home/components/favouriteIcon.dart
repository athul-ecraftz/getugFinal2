import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/home/favourite.dart';
import 'package:getug/screens/products/product_details.dart';
import 'dart:convert' as convert;
import 'package:getug/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteIcon extends StatefulWidget {
  final String? wishlisted;
  final String? id;

  const FavouriteIcon({
    Key? key,
    required this.wishlisted,
    required this.id,
  }) : super(key: key);

  @override
  State<FavouriteIcon> createState() => _FavouriteIconState();
}

class _FavouriteIconState extends State<FavouriteIcon> {
  bool isWishlisted = false;
  Favourite? favourite;
  late String productId;
  Future<Favourite> _addToFavourite(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString('userid').toString();

    Map<String, String> data = {"UserId": userid, "ProductId": productId};
    var response;
    if (isWishlisted) {
      // Remove from favorites
      response = await postJson("/api/removeFavourite", data);
    } else {
      // Add to favorites
      response = await postJson("/api/addFavourite", data);
    }
    // var response = await postJson("/api/addFavourite", data);
    if (response.statusCode == 200) {
      // print(response);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      setState(() {
        isWishlisted = !isWishlisted;
      });

      // print('Number of books about http: $itemCount.');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      jsonResponse['user'] = {};
      setState(() {
        favourite = Favourite.fromJson(jsonResponse);
      });
      // print(user);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return favourite!;
  }

  @override
  void initState() {
    super.initState();
    // Set initial state based on the wishlisted status
    isWishlisted = widget.wishlisted == 'Active';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _addToFavourite(widget.id!);
      },
      child: Container(
        padding: EdgeInsets.all(1.0), // Adjust padding as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Row(
          children: [
            Icon(
              isWishlisted ? Icons.favorite_rounded : Icons.favorite_outline,
              color: isWishlisted ? Colors.red : null,
            ),
          ],
        ),
      ),
    );
  }
}
