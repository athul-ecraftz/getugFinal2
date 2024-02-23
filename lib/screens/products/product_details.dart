import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/single_product/single_product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:getug/screens/home/components/recentProduct.dart';
import 'dart:convert' as convert;
import 'package:getug/screens/products/related_products.dart';

String? productId;

late Map<String, dynamic> args;
Map<String, dynamic>? dataresponse;

class ProductDetails extends StatefulWidget {
  static String routeName = '/productdetails';

  const ProductDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final CarouselController carouselController = CarouselController();

  late Single_product? category;

  late List<dynamic> covers = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch initial data when the widget is first initialized
  }

  Future<void> fetchData() async {
    final cat = await single_product();
    setState(() {
      category = cat;
      covers = category?.data?.cover ?? []; // Handle null or empty covers
    });
  }

  int currentIndex = 0;
  // void initState() {
  //   () async {
  //     final cat = await single_product();
  //     final cat1 = await related_product();
  //     setState(() {
  //       category = cat!;
  //       related = cat1!;
  //       Data? d = category!.data;
  //       corvers.addAll(category!.data!.cover as List<String>);
  //     });
  //   };
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     //  dataresponse!.clear();
  //     //print(category.status!);
  //   });
  // }

  Future<Single_product> single_product() async {
    var response = await getJson(
        "/api/fetchProductSinglePageLoad?ProductId=${args['productId']}");

    print('1');
    print(args['productId']);
    print('2');
    print('api call');
    print('3');
    Single_product? cat;
    Data? d;
    // print(response.toString());
    if (response.statusCode == 200) {
      // print(response);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];

      List<dynamic> data = jsonResponse['data']['cover'];
      covers = data;

      print(jsonResponse);
      print('4');

      cat = Single_product.fromJson(jsonResponse);
      dataresponse = jsonResponse['data'];
      // print('Number of books about http: $itemCount.');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];

      cat = Single_product.fromJson(jsonResponse);
      print('5');
      //print(user);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print('6');
    }

    return cat!;
  }

  Widget buildCard() {
    return Container(
      width: 114,
      height: 114,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff00ffffff),
            Color(0xffd6e7ff),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 176, 176, 176),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: const SizedBox(
        width: 5,
        height: 5,
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
          child: Image(
            image: AssetImage('assets/images/shoes1.jpg'),
            // color: Color.fromARGB(255, 169, 232, 232),
          ),
        ),
      ),
    );
  }

  // late GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print('args print');
    print(args);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // final cat = await single_product();
      // //   final cat1 = await related_product();
      // setState(() {
      //   category = cat;
      //   //  related = cat1;

      //   // Data? d = category!.data;
      //   // corvers.addAll(category!.data!.cover as List<String>);
      // });
    });
    // single_product();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ElevatedButton(
              //     onPressed: () async {
              //       Related_product relatedpro = await related_product();
              //       print(relatedpro.status);
              //     },
              //     child: Text("CLick")),
              // ElevatedButton(
              //     onPressed: () async {
              //       //   print(categorys.data!.cover);
              //     },
              //     child: Text("CLick")),
              //  Container(
              //   padding: EdgeInsets.only(bottom: 15),
              //   width: double.infinity,
              //   child: Image(
              //   image: NetworkImage(
              //   category!.data!.cover![0].toString(),
              //   ),
              //   ),
              //   ),
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
                          child:
                              //  Image(
                              //   image: NetworkImage(
                              //     category!.data!.cover![0].toString(),
                              //   ),
                              // ),

                              Image.network(
                            item.toString(),
                            fit: BoxFit.fill,
                          ),
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
                        decoration: const BoxDecoration(
                            // boxShadow: [
                            // BoxShadow(
                            //     color: const Color.fromARGB(255, 232, 230, 230),
                            //     spreadRadius: 4,
                            //     blurRadius: 2,
                            //     offset: Offset(0, 2)),
                            //  ],
                            ),
                        padding: const EdgeInsets.only(bottom: 5, left: 5),
                        //  alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // "Product Name",
                              category!.data!.name!.toString(),
                              textAlign: TextAlign.left,
                              // dataresponse!['name'].toString(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              // "1000",
                              'Ugx ${category!.data!.price!.toString()}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              // "Lorem ipsum dolor sit amet.",
                              category!.data!.description!.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Column(
                            //       children: [
                            //         // dataresponse == null
                            //         //     ? Container()
                            //         //     : Text(
                            //         //         // "Product Name",
                            //         //         category!.data!.name.toString(),
                            //         //         // dataresponse!['name'].toString(),
                            //         //         style: TextStyle(
                            //         //           fontSize: 22,
                            //         //           fontWeight: FontWeight.w600,
                            //         //         ),
                            //         //       ),
                            //       ],
                            //     ),
                            // Column(
                            //   children: [
                            //     Padding(
                            //         padding: EdgeInsets.only(left: 220)),
                            //     Icon(
                            //       Icons.favorite_border,
                            //       color: Colors.red,
                            //     ),
                            //   ],
                            // ),
                            //   ],
                            // ),
                            // Row(
                            //   children: [],
                            // ),
                            // Row(
                            //   children: [],
                            // ),
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
                        width: 400,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 232, 230, 230),
                                spreadRadius: 4,
                                blurRadius: 2,
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
                                      height: 120,
                                      width: 120,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          "Posted By",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          // "User Name",
                                          category!.data!.userDetail!.userName!
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          category!.data!.userDetail!.email!
                                              .toString(),
                                          // textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          category!
                                              .data!.userDetail!.mobileNumber!
                                              .toString(),
                                          // textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          category!.data!.createdOn!.toString(),
                                          // textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
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
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 400,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 232, 230, 230),
                                spreadRadius: 4,
                                blurRadius: 2,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          // "Posted At",
                                          category!.data!.address!.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/Map.png",
                                          height: 250,
                                          width: 400,
                                        ),
                                      ],
                                    ),
                                  ],
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

              // Container(child: RelatedProducts()),

              // Column(
              //   children: [
              //     Padding(padding: EdgeInsets.only(top: 15)),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           width: 410,
              //           height: 40,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             boxShadow: [
              //               BoxShadow(
              //                   color: Color.fromARGB(255, 232, 230, 230),
              //                   spreadRadius: 4,
              //                   blurRadius: 2,
              //                   offset: Offset(0, 2)),
              //             ],
              //           ),
              //           child: Column(
              //             children: [
              //               Row(
              //                 children: [
              //                   Padding(
              //                       padding:
              //                           EdgeInsets.only(left: 10, top: 40)),
              //                   Column(
              //                     children: [Text("AD ID:57219053")],
              //                   ),
              //                   Padding(
              //                       padding:
              //                           EdgeInsets.only(left: 120, top: 40)),
              //                   Column(
              //                     children: [
              //                       Text(
              //                         "REPORT THIS AD",
              //                         style: TextStyle(color: Colors.blue),
              //                       )
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // Column(
              //   children: [
              //     Row(
              //       children: [
              //         Container(
              //           padding: EdgeInsets.only(top: 20, left: 10),
              //           alignment: Alignment.centerLeft,
              //           child: Text(
              //             "Similar Products",
              //             style: TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         Expanded(
              //           child: Container(
              //             padding: EdgeInsets.only(
              //               left: 14,
              //             ),
              //             height: 90,
              //             child: ListView(
              //               scrollDirection: Axis.horizontal,
              //               physics: const BouncingScrollPhysics(
              //                   parent: AlwaysScrollableScrollPhysics()),
              //               children: [
              //                 buildCard(),
              //                 const SizedBox(
              //                   width: 15,
              //                 ),
              //                 buildCard(),
              //                 const SizedBox(
              //                   width: 15,
              //                 ),
              //                 buildCard(),
              //                 const SizedBox(
              //                   width: 15,
              //                 ),
              //                 buildCard(),
              //                 const SizedBox(
              //                   width: 15,
              //                 ),
              //                 buildCard(),
              //                 const SizedBox(
              //                   width: 15,
              //                 ),
              //                 buildCard(),
              //                 const SizedBox(
              //                   width: 15,
              //                 ),
              //               ],
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         SizedBox(
              //           height: 70,
              //         )
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ));
  }
}
