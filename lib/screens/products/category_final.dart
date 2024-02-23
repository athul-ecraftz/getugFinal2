import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/category/get_category.dart';
import 'package:getug/screens/home/components/favouriteIcon.dart';
import 'package:getug/screens/home/components/product_new.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/products/categorydrawer.dart';
import 'package:getug/screens/products/product_details.dart';
import 'dart:convert' as convert;
import 'package:getug/screens/products/suggested_products%20.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<_CategoryFinalState> categoryKey =
    GlobalKey<_CategoryFinalState>();

class CategoryFinal extends StatefulWidget {
  static String routeName = '/CategoryFinal';
  CategoryFinal({Key? key}) : super(key: key);

  @override
  State<CategoryFinal> createState() => _CategoryFinalState();
}

class _CategoryFinalState extends State<CategoryFinal> {
  late Future<Get_category> _categoryFuture;
  String selectedCategoryId = 'All';
  String selectedCategoryName = 'Category'; // Default value
  Get_category? fetchpost;

  @override
  void initState() {
    super.initState();
    _categoryFuture = get_category(selectedCategoryId);
    // _loadData();
  }

  Future<Get_category> get_category(selectedCategory) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userid');
    var url =
        "/api/getCategoryProductWhileLoad?limit=15&UserId=$userId&stateId=0";

    if (selectedCategory != 'All') {
      url =
          "/api/getCategoryProductByName?catId=$selectedCategory&UserId=$userId&limit=20&stateId=0";
    }
    // print(url);
    var response = await getJson(url);
    Get_category? cat;
    List<Data>? d;
    print(response.toString());
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      print(jsonResponse);
      cat = Get_category.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      cat = Get_category.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return cat!;
  }

  void updateCategory(newCategoryId, newCategoryName) {
    setState(() {
      selectedCategoryId = newCategoryId;
      selectedCategoryName = newCategoryName;
      _categoryFuture = get_category(selectedCategoryId);
    });
  }

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
        title: Row(
          children: [
            FutureBuilder<Get_category>(
              future: _categoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var fetchcategory = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.only(left: 88),
                    child: Text(selectedCategoryName),
                  );
                }
              },
            ),
            Spacer(),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.sort),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<Get_category?>(
                future: _categoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data?.data?.isEmpty == true) {
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
                            name: product.name ?? '',
                            price: product.price.toString() ?? '',
                            conditionName: product.conditionName ?? '',
                            productType: product.productType ?? '',
                            coverImage: product.cover ?? '',
                            productId: product.id.toString(),
                            wishlist: product.wishlist ?? '',
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              const Row(
                children: [
                  Text("Suggested Products",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 17)),
                  SizedBox(
                    height: 55,
                  ),
                ],
              ),
              Container(child: const SuggestedProducts()),
            ],
          ),
        ),
      ),
      drawer: CategoryDrawer(
        onCategorySelected: (selectedCategoryId, selectedCategoryName) {
          updateCategory(selectedCategoryId, selectedCategoryName);
          print('Selected Category ID: $selectedCategoryId');
        },
      ),
    );
  }
}

class SinglePro extends StatelessWidget {
  final String name;
  final String price;
  final String conditionName;
  final String productType;
  final String coverImage;
  final String productId;
  final String wishlist;

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
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: coverImage != 'https://dev.get-ug.com/'
                        ? NetworkImage(coverImage)
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
                      FavouriteIcon(wishlisted: wishlist, id: productId)
                      // Icon(Icons.favorite)
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
//                 Expanded(
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 8.0,
//                       mainAxisSpacing: 8.0,
//                     ),
//                     itemCount: snapshot.data!.data!.length,
//                     itemBuilder: (context, index) {
//                       return buildCard(snapshot.data!.data![index]);
//                     },
//                   ),
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
