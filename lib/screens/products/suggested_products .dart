import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/get_suggested_products/suggested_products.dart';
import 'package:getug/screens/home/components/product_new.dart';
import 'package:getug/screens/products/product_details.dart';
import 'package:getug/screens/products/product_image.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class SuggestedProducts extends StatefulWidget {
  static String routeName = '/suggestedproducts';
  const SuggestedProducts({Key? key}) : super(key: key);

  @override
  _SuggestedProductsState createState() => _SuggestedProductsState();
}

class _SuggestedProductsState extends State<SuggestedProducts> {
  late Future<suggested_products> _suggestedProductsFuture;
  late Future<suggested_products?> fetchProducts;

  @override
  void initState() {
    super.initState();
    _suggestedProductsFuture = SuggestedProduct();
    fetchProducts = _loadData();
  }

  Future<suggested_products?> _loadData() async {
    try {
      final getpost = await SuggestedProduct();
      print('Setting state for fetchProducts...');
      return getpost;
    } catch (e) {
      print('Error loading data: $e');
      return null;
    }
  }

  Future<suggested_products> SuggestedProduct() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userid');
    var response = await getJson("/api/getSuggestedProducts?UserId=$userId");
    suggested_products? cat1;
    List<Data>? d;
    print(response.toString());
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      print(jsonResponse);
      cat1 = suggested_products.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      cat1 = suggested_products.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return cat1!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<suggested_products?>(
      future: _suggestedProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data?.data?.isEmpty == true) {
          return const Center(child: Text('No data available'));
        } else {
          var fetchcategory = snapshot.data;
          return Center(
            child: GridView.count(
              childAspectRatio: 0.95,
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.data!.map((product) {
                return SinglePro(
                  id: product.id.toString() ?? '',
                  name: product.name ?? '',
                  price: product.price ?? '',
                  productType: product.productType ?? '',
                  cover: product.cover ?? '',
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}

class SinglePro extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String productType;
  final String cover;
  // final String conditionName;
  //   final String name;
  // final String price;
  // final String productType;
  // final String coverImage;
  // final String productId;
  const SinglePro({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
    required this.productType,
    required this.cover,
    // required this.conditionName,
    //     required this.name,
    // required this.price,
    // required this.productType,
    // required this.coverImage,
    // required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          NewProduct.routeName,
          arguments: {'productId': id, "name": name},
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
                    image: cover.toString() != 'https://dev.get-ug.com/'
                        ? NetworkImage(cover.toString())
                        : const NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
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
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 3),
              child: Column(
                children: [
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 10, top: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$name",
                            style: const TextStyle(
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

// import 'package:flutter/material.dart';
// import 'package:getug/common/apiconnect.dart';
// import 'package:getug/models/get_suggested_products/suggested_products.dart';
// import 'dart:convert' as convert;
// import 'package:shared_preferences/shared_preferences.dart';

// class SuggestedProducts extends StatefulWidget {
//   static String routeName = '/suggestedproducts';
//   const SuggestedProducts({Key? key}) : super(key: key);

//   @override
//   State<SuggestedProducts> createState() => _SuggestedProductsState();
// }

// class _SuggestedProductsState extends State<SuggestedProducts> {
//   late suggested_products sugested;
//   late Future<suggested_products?> fetchProducts;

//   @override
//   void initState() {
//     fetchData();
//     super.initState();
//   }

//   Future<void> fetchData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('userid');
//     final cat1 = await SuggestedProduct(userId.toString());
//     userId:
//     int.parse(userId!);
//     print(userId);
//     setState(() {
//       sugested = cat1;
//       fetchProducts = SuggestedProduct(userId.toString());
//     });
//   }

//   Future<suggested_products> SuggestedProduct(String? userId) async {
//     var response = await getJson("/api/getSuggestedProducts?UserId=$userId");
//     suggested_products? cat1;
//     Data? d;
//     print(response.toString());
//     if (response.statusCode == 200) {
//       var jsonResponse =
//           convert.jsonDecode(response.body) as Map<String, dynamic>;
//       var itemCount = jsonResponse['data'];
//       print(jsonResponse);
//       cat1 = suggested_products.fromJson(jsonResponse);
//     } else if (response.statusCode == 400) {
//       var jsonResponse =
//           convert.jsonDecode(response.body) as Map<String, dynamic>;
//       var itemCount = jsonResponse['data'];
//       cat1 = suggested_products.fromJson(jsonResponse);
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//     return cat1!;
//   }

//   Widget buildCard(Data? data) {
//     return Container(
//       width: 120,
//       height: 500,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Colors.white,
//             Colors.white,
//           ],
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//         boxShadow: [
//           BoxShadow(
//             color: Color.fromARGB(255, 176, 176, 176),
//             blurRadius: 2.0,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: data!.cover.toString() != 'https://dev.get-ug.com/'
//                   ? Image.network(
//                       data!.cover.toString(),
//                       fit: BoxFit.cover,
//                     )
//                   : Image.network(
//                       "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png"),
//             ),
//             SizedBox(height: 5),
//             Text(
//               data.name ?? '',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontFamily: 'Arial',
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               "Ugx ${data.price}",
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Colors.black,
//                 fontFamily: 'Arial',
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<suggested_products?>(
//       future: fetchProducts,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.hasData && snapshot.data!.data != null) {
//           return Container(
//             height: 200,
//             width: 600,
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.only(top: 20, left: 15),
//                       alignment: Alignment.centerLeft,
//                       child: const Text(
//                         "Suggested Products",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 8.0,
//                     mainAxisSpacing: 8.0,
//                   ),
//                   itemCount: snapshot.data!.data!.length,
//                   itemBuilder: (context, index) {
//                     return buildCard(snapshot.data!.data![index]);
//                   },
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return Text('No data available');
//         }
//       },
//     );
//   }
// }
