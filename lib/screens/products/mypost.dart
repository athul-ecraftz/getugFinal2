import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/my_post/deleteProduct.dart';
import 'package:getug/models/my_post/notSoldupdateProductStatusById.dart';
import 'package:getug/models/my_post/post_page.dart';
import 'package:getug/models/my_post/reservedupdateProductStatusById.dart';
import 'package:getug/models/my_post/soldupdateProductStatusById.dart';
import 'package:getug/screens/home/components/favouriteIcon.dart';
import 'package:getug/screens/home/components/product_new.dart';
import 'dart:convert' as convert;
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/products/mypost_edit.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<Mypost?>(
                future: _fetchPostFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data?.data?.isEmpty == true) {
                    return const Center(child: Text('No data available'));
                  } else {
                    var fetchPost = snapshot.data;
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
            ],
          ),
        ),
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

class SinglePro extends StatelessWidget {
  final String name;
  final String price;
  final String conditionName;
  final String coverImage;
  final String productId;
  final String wishlist;

  const SinglePro({
    Key? key,
    required this.name,
    required this.price,
    required this.conditionName,
    required this.coverImage,
    required this.productId,
    required this.wishlist,
  }) : super(key: key);

  Future<DeleteProduct> deleteProduct1(BuildContext context, String pId) async {
    Map<String, String> data = {};

    DeleteProduct? deletePro;

    var response = await postJson1("/api/deleteproduct?productId=$pId");
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var msg = jsonResponse['data'];
      // Product deleted successfully

      if (msg is String) {
        print(msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text(
              msg,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        jsonResponse['data'] = msg.toString();
      }
      print("New= $jsonResponse");

      //var itemCount = jsonResponse['data'];
      deletePro = DeleteProduct.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      var msg = jsonResponse['data'];

      deletePro = DeleteProduct.fromJson(jsonResponse);
      print(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return deletePro!;
  }

  Future<SoldUpdateProductById> soldUpdateProduct(
      BuildContext context, String pId) async {
    Map<String, String> data = {};

    SoldUpdateProductById? soldPro;

    var response = await postJson1(
        "/api/updateProductStatusById?productId=$pId&statusId=2");
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var msg = jsonResponse['data'];
      // Product deleted successfully

      if (msg is String) {
        print(msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text(
              msg,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        jsonResponse['data'] = msg.toString();
      }
      print("New= $jsonResponse");

      //var itemCount = jsonResponse['data'];
      soldPro = SoldUpdateProductById.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      var msg = jsonResponse['data'];

      soldPro = SoldUpdateProductById.fromJson(jsonResponse);
      print(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return soldPro!;
  }

  Future<NotSoldUpdateProductById> notsoldUpdateProduct(
      BuildContext context, String pId) async {
    Map<String, String> data = {};

    NotSoldUpdateProductById? notSoldPro;

    var response = await postJson1(
        "/api/updateProductStatusById?productId=$pId&statusId=1");
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var msg = jsonResponse['data'];
      // Product deleted successfully

      if (msg is String) {
        print(msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text(
              msg,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        jsonResponse['data'] = msg.toString();
      }
      print("New= $jsonResponse");

      //var itemCount = jsonResponse['data'];
      notSoldPro = NotSoldUpdateProductById.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      var msg = jsonResponse['data'];

      notSoldPro = NotSoldUpdateProductById.fromJson(jsonResponse);
      print(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return notSoldPro!;
  }

  Future<ReservedUpdateProductById> reservedUpdateProduct(
      BuildContext context, String pId) async {
    Map<String, String> data = {};

    ReservedUpdateProductById? ReservedUpdate;

    var response = await postJson1(
        "/api/updateProductStatusById?productId=$pId&statusId=1");
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var msg = jsonResponse['data'];
      // Product deleted successfully

      if (msg is String) {
        print(msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text(
              msg,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        jsonResponse['data'] = msg.toString();
      }
      print("New= $jsonResponse");

      //var itemCount = jsonResponse['data'];
      ReservedUpdate = ReservedUpdateProductById.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      var msg = jsonResponse['data'];

      ReservedUpdate = ReservedUpdateProductById.fromJson(jsonResponse);
      print(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return ReservedUpdate!;
  }

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
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:
                            FavouriteIcon(wishlisted: wishlist, id: productId),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(47, 235, 235,
                              235), // Set the background color to white
                          borderRadius: BorderRadius.circular(
                              50), // Set the border radius
                        ),
                        child: PopupMenuButton(
                          color: Colors.white,
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('edit'),
                                ),
                                value: 'edit',
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ),
                                value: 'delete',
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.shopping_bag),
                                  title: Text('Mark as Sold'),
                                ),
                                value: 'sold',
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.shopping_bag_sharp),
                                  title: Text('Mark as Not Sold'),
                                ),
                                value: 'notSold',
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.shopping_basket_outlined),
                                  title: Text('Mark as Reserved'),
                                ),
                                value: 'reserved',
                              ),
                            ];
                          },
                          onSelected: (value) {
                            // Handle the selected option
                            print('Selected: $value');
                            if (value == 'delete') {
                              String pId = productId;
                              deleteProduct1(context, pId);
                            }
                            if (value == 'sold') {
                              String pId = productId;
                              soldUpdateProduct(context, pId);
                            }
                            if (value == 'notSold') {
                              String pId = productId;
                              notsoldUpdateProduct(context, pId);
                            }
                            if (value == 'edit') {
                              Navigator.pushNamed(
                                context,
                                MypostEdit.routeName,
                                arguments: {'productId': productId},
                              );
                            }
                          },
                        ),
                      ),
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
