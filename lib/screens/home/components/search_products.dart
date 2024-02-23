import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/single_product/related_product.dart';
import 'package:getug/screens/home/components/favouriteIcon.dart';
import 'package:getug/screens/home/components/product_new.dart';
import 'package:getug/screens/products/product_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

late Map<String, dynamic> args;

class SearchProducts extends StatefulWidget {
  String? searchText;

  SearchProducts({
    Key? key,
    required this.searchText,
  }) : super(key: key);

  @override
  State<SearchProducts> createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  late Future<Related_product?> fetchProducts;

  @override
  void initState() {
    super.initState();
    //  print('-...${widget.categoryId}');
    fetchProducts = _loadData();
  }

  Future<Related_product?> _loadData() async {
    try {
      final getpost = await getMypost(widget.searchText);
      //   print('-...$categoryId');
      return getpost;
    } catch (e) {
      print('Error loading data: $e');
      return null;
    }
  }

  Future<Related_product?> getMypost(var categoryid) async {
    print('Fetching mypost data...');
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString('userid').toString();
    Map<String, String> data1 = {
      "UserId": userid,
      "SearchKey": widget.searchText!,
      "stateId": "0"
    };
    var url = "/api/getSearchProducts";
    // print(url);
    var response = await postJson(url, data1);
    Related_product? getpost;
    List<Data1>? data;
    // print(response.toString());
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      // print('reklATED screen');
      //print(jsonResponse);
      getpost = Related_product.fromJson(jsonResponse);
      // Print the product list for debugging
      // print('Product list: ${getpost?.data}');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      getpost = Related_product.fromJson(jsonResponse);
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.searchText!)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Related_product?>(
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
                      childAspectRatio: 0.98,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.data!.map((product) {
                        return RelatedPro(
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
            ),
          ],
        ),
      ),
    );
  }
}

class RelatedPro extends StatelessWidget {
  final String? name;
  final String? price;
  final String? conditionName;
  final String? productType;
  final String? coverImage;
  final String? productId;
  final String? wishlist;

  const RelatedPro({
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
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: coverImage != "https://dev.get-ug.com/"
                      ? NetworkImage(coverImage!) // Use the cover image URL
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
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
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
