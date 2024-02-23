import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/home/home_products.dart';
import 'package:getug/screens/home/components/appbar.dart';
import 'package:getug/screens/home/components/recentProduct.dart';
import 'package:getug/screens/home/components/search_products.dart';
import 'package:getug/screens/home/components/singleProduct.dart';
import 'package:getug/screens/home/components/user_location.dart';
import 'package:getug/screens/notification/notification.dart';
import 'package:getug/screens/products/category_final.dart';
import 'package:getug/screens/products/favourite.dart';

import 'dart:convert' as convert;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<dynamic> imageList = [];
  bool isSearching = false;
  String? locationName = 'Loading...';
  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          locationName =
              "${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country} ";
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        locationName = '...';
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        // Location permission granted, fetch location
        await _getLocation();
      } else {
        // Location permission denied
        print('Location permission denied');
        setState(() {
          locationName = '...';
        });
      }
    } else {
      // Location permission already granted, fetch location
      await _getLocation();
    }
  }

  @override
  void initState() {
    print('initState called.');
    super.initState();
    fetchData();
    _getLocation();
  }

  Future<void> fetchData() async {
    await fetchSlider();
  }

  Future<void> fetchSlider() async {
    try {
      var response = await getJson("/api/getAllSliderForUser");
      if (response.statusCode == 200) {
        final json = convert.jsonDecode(response.body);
        List<dynamic> data = json["data"];
        setState(() {
          imageList = data;
        });
      } else if (response.statusCode == 500 || response.statusCode == 404) {
        setState(() {
          imageList = [
            {
              "sliderImage":
                  "https://media.tenor.com/zecVkmevzcIAAAAC/please-wait.gif"
            }
          ];
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error fetching slider: $e');
    }
  }

  final CarouselController carouselController = CarouselController();

  String categoryImage = '';
  String categoryName = '';

  int currentIndex = 0;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('Building widget...');
    return Scaffold(
      appBar: appBarHome(
        title: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              print('Clicked location');
              _requestLocationPermission();
            },
            child: Text.rich(
              TextSpan(
                children: [
                  const WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ),
                  WidgetSpan(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '$locationName',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          //  IconButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, ProductDetails.routeName);
          //   },
          //   icon: const Icon(Icons.notifications_outlined),
          //   color: Color(0xff2067d2),
          // ),
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
              Navigator.pushNamed(context, FavouriteItems.routeName);
            },
            icon: const Icon(Icons.favorite_border_outlined),
            color: Color(0xff2067d2),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, NotificationScreen.routeName);
            },
            icon: const Icon(Icons.notifications_outlined),
            color: Color(0xff2067d2),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft:
                      Radius.circular(10.0), // Adjust the radius as needed
                  bottomRight:
                      Radius.circular(10.0), // Adjust the radius as needed
                ),
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: InkWell(
                            onTap: () {
                              print(currentIndex);
                            },
                            child: CarouselSlider(
                              items: imageList
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
                                        child: Image.network(
                                          item["sliderImage"],
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
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 2,
                          right: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imageList.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    carouselController.animateToPage(entry.key),
                                child: Container(
                                  width: currentIndex == entry.key ? 17 : 7,
                                  height: 7.0,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3.0,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: currentIndex == entry.key
                                          ? Colors.blue
                                          : Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0, // Adjust the top position as needed
                left: 15, // Adjust the left position as needed
                right: 15, // Adjust the right position as needed
                child: Visibility(
                  visible: isSearching,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return SearchProducts(
                                      searchText: search.text,
                                    );
                                  }));
                                }
                              },
                              icon: Icon(Icons.search)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 75, 96, 112)),
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
            ],
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text("Categories",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                      SizedBox(
                        height: 45,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 110,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            children: const [
                              homeCategoryItems(
                                categoryImage: 'assets/images/car.png',
                                categoryName: 'Car',
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              homeCategoryItems(
                                categoryImage: 'assets/images/motorcycle.png',
                                categoryName: 'Motor Cycle',
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              homeCategoryItems(
                                categoryImage: 'assets/images/mobile-app.png',
                                categoryName: 'Mobile Phones',
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              homeCategoryItems(
                                categoryImage: 'assets/images/dress.png',
                                categoryName: 'Dress',
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              homeCategoryItems(
                                categoryImage: 'assets/images/sofa.png',
                                categoryName: 'Furniture',
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              homeCategoryItems(
                                categoryImage: 'assets/images/building.png',
                                categoryName: 'Apartment',
                              ),
                              SizedBox(
                                width: 12,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text("Recently viewed",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18)),
                            SizedBox(
                              height: 45,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(child: RecentProduct()),
                        const SizedBox(
                          height: 12,
                        ),
                        const Row(
                          children: [
                            Text("Recommended for you",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18)),
                            SizedBox(
                              height: 55,
                            ),
                          ],
                        ),
                        Container(child: SingleProduct()),
                      ],
                    ),
                  ),
                ],
              ))
        ]),
      ),
    );
  }
}

class homeCategoryItems extends StatelessWidget {
  final String categoryImage;
  final String categoryName;
  const homeCategoryItems({
    super.key,
    required this.categoryImage,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(31, 114, 113, 113)),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff00ffffff),
                  Color(0xffd6e7ff),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryFinal()));
                    },
                    child: Image(
                      image: AssetImage(categoryImage),
                      color: Colors.blue,
                    ),
                  ),
                ),
                // Text('data'),
              ],
            ),

            // child: Column(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.all(15),
            //       child: Image(
            //         image: AssetImage(categoryImage),
            //         color: Colors.blue,
            //       ),
            //     ),
            //     // Text('data'),
            //   ],
            // ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          categoryName,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
