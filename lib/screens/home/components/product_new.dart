import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/constants.dart';
import 'package:getug/models/single_product/single_product.dart';
import 'package:getug/screens/chat_screen/chat_page.dart';
import 'package:getug/screens/home/components/recentProduct.dart';
import 'package:getug/screens/home/components/search_products.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import 'package:getug/screens/products/related_products.dart';

class NewProduct extends StatefulWidget {
  static String routeName = '/newproduct';

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final CarouselController carouselController = CarouselController();
  bool isSearching = false;
  late List<dynamic> covers = [];
  late Map<String, dynamic> args;
  Single_product? productDetails; // Holds the fetched product details
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await fetchSingleProduct(args['productId']);
      // Pass the productId to the fetch method
      covers = productDetails!.data!.cover!;
    });

    super.initState();
    save();
    // Fetch the product details when the widget is first initialized
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString('userid').toString();
    await Saverecentproduct(args['productId'], userid);
  }

  int currentIndex = 0;

  Future<void> fetchSingleProduct(String productId) async {
    var url = "/api/fetchProductSinglePageLoad?ProductId=$productId";
    Single_product? sp;
    var response = await getJson(url);
    // print(args['productId']);

    if (response.statusCode == 200 || response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      // print(jsonResponse);
      setState(() {
        productDetails = Single_product.fromJson(jsonResponse);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> Saverecentproduct(String productId, String userid) async {
    Map<String, String> data = {"UserId": userid, "ProductId": productId};
    var url = "/api/saveRecentViewProduct";
    // print(url);

    var response = await postJson(url, data);
    //print(args['productId']);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      // var itemCount = jsonResponse['data'];
      // print(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  // Widget buildCard() {
  //   return Container(
  //     width: 114,
  //     height: 114,
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [
  //           Color(0xff00ffffff),
  //           Color(0xffd6e7ff),
  //         ],
  //       ),
  //       borderRadius: BorderRadius.all(Radius.circular(12)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Color.fromARGB(255, 176, 176, 176),
  //           blurRadius: 2.0,
  //         ),
  //       ],
  //     ),
  //     child: const SizedBox(
  //       width: 5,
  //       height: 5,
  //       child: Padding(
  //         padding: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
  //         child: Image(
  //           image: AssetImage('assets/images/shoes1.jpg'),
  //           // color: Color.fromARGB(255, 169, 232, 232),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('${args["name"]}'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
            icon: Icon(Icons.search),
            color: Color(0xff2067d2),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
            icon: const Icon(Icons.home),
            color: Color(0xff2067d2),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            productDetails != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Visibility(
                          visible: isSearching,
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: search,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        if (search.text.isNotEmpty) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (ctx) {
                                            return SearchProducts(
                                              searchText: search.text,
                                            );
                                          }));
                                        }
                                      },
                                      icon: Icon(Icons.search)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 75, 96, 112)),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // You can adjust the radius as needed
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // You can adjust the radius as needed
                                  ),
                                ),
                              )),
                        ),
                      ),
                      CarouselSlider(
                        items: covers
                            .map(
                              (item) => Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                  child: item.toString() !=
                                          "https://dev.get-ug.com/"
                                      ? Image.network(
                                          item.toString(),
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",
                                          fit: BoxFit.fill,
                                        ), // Default image if cover is null
                                ),
                              ),
                            )
                            .toList(),
                        carouselController: carouselController,
                        options: CarouselOptions(
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: const BoxDecoration(),
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 5),
                                //  alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productDetails!.data!.name!.toString(),
                                      textAlign: TextAlign.left,
                                      // dataresponse!['name'].toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Ugx ${productDetails!.data!.price!.toString()}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      // "Lorem ipsum dolor sit amet.",
                                      productDetails!.data!.description!
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 350,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 232, 230, 230),
                                        spreadRadius: 2,
                                        blurRadius: 1,
                                        offset: Offset(0, 2)),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/profile.png",
                                              height: 130,
                                              width: 130,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Row(
                                                children: [
                                                  Text(
                                                    "Posted By",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Arial',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    // "User Name",
                                                    productDetails!.data!
                                                        .userDetail!.userName!
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      //   fontFamily: 'Arial',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    productDetails!.data!
                                                        .userDetail!.email!
                                                        .toString(),
                                                    // textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Visibility(
                                                    visible: productDetails
                                                            ?.data
                                                            ?.userDetail
                                                            ?.mobileNumber !=
                                                        null,
                                                    child: Text(
                                                      productDetails!
                                                              .data!
                                                              .userDetail!
                                                              .mobileNumber
                                                              .toString() ??
                                                          "",
                                                      // textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Date : ${productDetails!.data!.createdOn!.toString()}',
                                                    // textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 350,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 232, 230, 230),
                                        spreadRadius: 2,
                                        blurRadius: 1,
                                        offset: Offset(0, 2)),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  // "Posted At",
                                                  productDetails!.data!.address!
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/images/Map.png",
                                                height: 250,
                                                width: 350,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          const Text(
                            "Related Products",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RelatedProducts(
                              categoryId:
                                  productDetails!.data!.categoryId!.toString(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Chat called');
          Navigator.pushNamed(
            context,
            ChatPage.routeName,
            arguments: {
              'productId': productDetails!.data!.id ?? '',
              'userId': productDetails!.data!.userDetail!.userId ?? ''
            },
          );
        },
        child: Icon(Icons.chat, color: Colors.white),
        backgroundColor:
            Color.fromARGB(255, 62, 188, 219), // Customize the button color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
