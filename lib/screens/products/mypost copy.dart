import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/my_post/post_page.dart';
import 'dart:convert' as convert;

import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPost extends StatefulWidget {
  const MyPost({Key? key}) : super(key: key);
  static String routeName = '/MyPost';

  @override
  State<MyPost> createState() => _Get_MyPostState();
}

class _Get_MyPostState extends State<MyPost> {
  late Future<Mypost> _fetchPostFuture;

  @override
  void initState() {
    super.initState();
    _fetchPostFuture = get_mypost();
  }

  Future<Mypost> get_mypost() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userid');
    var response = await getJson("/api/getMyPostProduct?UserId=$userId");
    Mypost? getpost;
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      getpost = Mypost.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      getpost = Mypost.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return getpost!;
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
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 80),
              child: Text('My Post'),
            ),
            Spacer(),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: 300,
            margin: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 176, 176, 176),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<Mypost>(
                      future: _fetchPostFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData &&
                            snapshot.data!.data != null &&
                            snapshot.data!.data!.isNotEmpty) {
                          Data firstProduct = snapshot.data!.data![0];
                          String coverUrl;
                          if (firstProduct.cover == "https://dev.get-ug.com/") {
                            coverUrl =
                                "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
                          } else if (firstProduct.cover ==
                              "https://dev.get-ug.com/2a879884-8ff3-4f63-9e2e-95afbdecd80a.jpeg") {
                            coverUrl =
                                "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
                          } else if (firstProduct.cover ==
                              "https://dev.get-ug.com/3900a9fa-a751-45e0-b911-961295eaea85.jpeg") {
                            coverUrl =
                                "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
                          } else {
                            coverUrl = firstProduct.cover ??
                                "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
                          }

                          return GestureDetector(
                            onTap: () {
                              // Handle tap on the first product image
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                    imageUrl: coverUrl,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                  image: NetworkImage(coverUrl),
                                  height: 200,
                                  width: 200,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          firstProduct.name ?? "Product Name",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          firstProduct.price?.toString() ??
                                              "Price",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          firstProduct.conditionName ??
                                              "Condition",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Text('No data available');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 255,
            child: FutureBuilder<Mypost>(
              future: _fetchPostFuture,
              builder: (BuildContext context, AsyncSnapshot<Mypost> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data!.data == null ||
                    snapshot.data!.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 1),
                        child: _buildProductContainer(
                          snapshot.data!.data![index],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductContainer(Data product) {
    String coverUrl;
    if (product.cover == "https://dev.get-ug.com/") {
      coverUrl =
          "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
    } else if (product.cover ==
        "https://dev.get-ug.com/2a879884-8ff3-4f63-9e2e-95afbdecd80a.jpeg") {
      coverUrl =
          "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
    } else if (product.cover ==
        "https://dev.get-ug.com/3900a9fa-a751-45e0-b911-961295eaea85.jpeg") {
      coverUrl =
          "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
    } else {
      coverUrl = product.cover ??
          "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png";
    }

    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 176, 176, 176),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Handle tap on the product image
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                    imageUrl: coverUrl,
                  ),
                ),
              );
            },
            child: Image(
              image: NetworkImage(coverUrl),
              height: 153.0,
              width: 155.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(product.name ?? "Product Name"),
          Text(product.price?.toString() ?? "Price"),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
