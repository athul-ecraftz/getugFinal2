import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/home/recent_products.dart';
import 'package:getug/screens/home/components/favouriteIcon.dart';
import 'package:getug/screens/home/components/product_new.dart';
import 'package:getug/screens/products/product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:getug/size_config.dart';

late Map<String, dynamic> args;

class RecentProduct extends StatefulWidget {
  const RecentProduct({
    super.key,
    //  required this.coverimage, required this.price
  });

  @override
  State<RecentProduct> createState() => _RecentProductState();
}

class _RecentProductState extends State<RecentProduct> {
  late Future<Recent_products?> fetchProducts;

  @override
  void initState() {
    super.initState();
    fetchProducts = _loadData();
  }

  Future<Recent_products?> _loadData() async {
    try {
      final getpost = await getMypost();
      print('Setting state for fetchProducts...');
      return getpost;
    } catch (e) {
      print('Error loading data: $e');
      return null;
    }
  }

  Future<Recent_products?> getMypost() async {
    print('Fetching mypost data...');
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString('userid').toString();
    var response = await getJson("/api/recentlyViewedProducts?userid=$userid");
    Recent_products? getpost;
    List<Data>? data;
    // print(response.toString());
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      print('home screen');
      // print(jsonResponse);
      getpost = Recent_products.fromJson(jsonResponse);
      // Print the product list for debugging
      // print('Product list: ${getpost?.data}');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      getpost = Recent_products.fromJson(jsonResponse);
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
    return FutureBuilder<Recent_products?>(
      future: fetchProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.data != null) {
          return Center(
            child: GridView.count(
              childAspectRatio: 0.95,
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.data!.map((product) {
                return SinglePro(
                  name: product.name,
                  price: product.price,
                  conditionName: product.conditionName,
                  productType: product.productType,
                  coverImage: product.cover,
                  productId: product.id.toString(),
                  wishlist: product.wishlist,
                );
              }).toList(),
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}

class SinglePro extends StatelessWidget {
  final String? name;
  final String? price;
  final String? conditionName;
  final String? productType;
  final String? coverImage;
  final String? productId;
  final String? wishlist;

  const SinglePro({
    Key? key,
    required this.name,
    required this.price,
    required this.conditionName,
    required this.productType,
    required this.coverImage,
    required this.productId,
    required this.wishlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
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
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: coverImage != ''
                        ? NetworkImage(coverImage!) // Use the cover image URL
                        : const NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png"), // Default image if cover is null
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 35,
                        height: 20,
                        padding: const EdgeInsets.all(1),
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
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 3),
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     Container(
                  //       margin: const EdgeInsets.all(0),
                  //       child: Image.asset(
                  //         "assets/images/car-ac-101.jpg",
                  //         height:
                  //             getProportionateScreenHeight(
                  //                 100),
                  //         width:
                  //             getProportionateScreenWidth(
                  //                 100),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       padding: const EdgeInsets.only(
                  //         bottom: 8,
                  //         left: 8,
                  //         top: 2,
                  //       ),
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         "Ugx $price",
                  //         style: TextStyle(
                  //           fontSize: 14,
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ugx $price",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       padding: EdgeInsets.all(8),
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         "$name",
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10, top: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$name",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Arial',
                              color: Colors.black,
                            ),
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
