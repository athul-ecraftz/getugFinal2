import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/get_wishlist_products/get_wishlist.dart';
import 'package:getug/screens/home/components/favouriteIcon.dart';
import 'package:getug/screens/home/components/product_new.dart';

import 'package:getug/screens/products/product_details.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class FavouriteItems extends StatefulWidget {
  static String routeName = '/favourite';
  const FavouriteItems({
    super.key,
    //  required this.coverimage, required this.price
  });

  @override
  State<FavouriteItems> createState() => _FavouriteItemsState();
}

class _FavouriteItemsState extends State<FavouriteItems> {
  late Future<get_wishlist?> fetchProducts;

  @override
  void initState() {
    super.initState();
    fetchProducts = _loadData();
  }

  Future<get_wishlist?> _loadData() async {
    try {
      final getpost = await getwishlist();
      print('Setting state for fetchProducts...');
      return getpost;
    } catch (e) {
      print('Error loading data: $e');
      return null;
    }
  }

  Future<get_wishlist?> getwishlist() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString('userid').toString();
    var response = await getJson("/api/getWishlisProducts?UserId=$userid");
    get_wishlist? getpost;
    List<Data>? data;
    print(response.toString());
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];

      print(jsonResponse);
      getpost = get_wishlist.fromJson(jsonResponse);
      // Print the product list for debugging
      print('favourite: ${getpost?.data}');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      getpost = get_wishlist.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return getpost!;
  }

  @override
  Widget build(BuildContext context) {
    if (fetchProducts == null) {
      fetchProducts = _loadData();
    }
    return FutureBuilder<get_wishlist?>(
      future: fetchProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.data != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Favourite", style: TextStyle(fontSize: 21)),
            ),
            body: SafeArea(
              child: GridView.count(
                childAspectRatio: 1.0,
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: snapshot.data!.data!.map((product) {
                  return favourite_list(
                    productId: product.id.toString(),
                    name: product.name,
                    price: product.price,
                    conditionName: product.conditionName,
                    productType: product.productType,
                    cover: product.cover,
                  );
                }).toList(),
              ),
            ),
          );
        } else {
          // return Text('No data available');

          return Scaffold(
            appBar: AppBar(
              title: Text("Favourite", style: TextStyle(fontSize: 21)),
            ),
            body: SafeArea(
              child: Center(
                child: Text("No Data available"),
              ),
            ),
          );
        }
      },
    );
  }
}

class favourite_list extends StatelessWidget {
  String? productId;
  String? name;
  String? price;
  String? conditionName;
  String? cover;
  String? productType;

  favourite_list({
    Key? key,
    required this.productId,
    required this.name,
    required this.price,
    required this.conditionName,
    required this.cover,
    required this.productType,
  }) : super(key: key);

  String wishlist = 'Active';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          NewProduct.routeName,
          arguments: {'productId': productId, "name": name},
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 219, 218, 218),
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: cover != "https://dev.get-ug.com/"
                      ? NetworkImage(cover!) // Use the cover image URL
                      : const NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png"), // Default image if cover is null
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 5, right: 5, bottom: 75, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 35,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: productType == 'Sale'
                            ? Colors.green
                            : (productType == 'Rent'
                                ? Colors.blue
                                : const Color.fromARGB(255, 5, 94, 148)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "$productType",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    FavouriteIcon(wishlisted: wishlist, id: productId)
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          left: 8,
                          top: 2,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ugx $price",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$name",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
