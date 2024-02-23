// import 'package:flutter/material.dart';
// import 'package:getug/common/apiconnect.dart';
// import 'package:getug/models/my_post/post_page.dart';
// import 'package:getug/screens/home/home_screen.dart';
// import 'dart:convert' as convert;

// import 'package:getug/size_config.dart';

// class MyPost extends StatefulWidget {
//   static String routeName = '/category';
//   const MyPost({super.key});

//   @override
//   State<MyPost> createState() => _MyPostState();
// }

// class _MyPostState extends State<MyPost> {
//   Future<Mypost> get_mypost() async {
//     var response = await getJson("/api/getMyPostProduct?UserId=32");
//     Mypost? getpost;
//     List<Data>? data;
//     print(response.toString());
//     if (response.statusCode == 200) {
//       var jsonResponse =
//           convert.jsonDecode(response.body) as Map<String, dynamic>;
//       var itemCount = jsonResponse['data'];
//       print(jsonResponse);
//       getpost = Mypost.fromJson(jsonResponse);
//     } else if (response.statusCode == 400) {
//       var jsonResponse =
//           convert.jsonDecode(response.body) as Map<String, dynamic>;
//       var itemCount = jsonResponse['data'];
//       getpost = Mypost.fromJson(jsonResponse);
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//     return getpost!;
//   }

//   Mypost? fetchpost;
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPersistentFrameCallback((_) async {
//       final getpost = await get_mypost();
//       setState(() {
//         fetchpost = getpost;
//         late List<Data>? d = fetchpost!.data!;
//       });
//     });

//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.only(top: 1),
//           child: IconButton(
//             onPressed: () {
//               Navigator.pushNamed(context, HomeScreen.routeName);
//             },
//             icon: const Icon(Icons.arrow_back_ios),
//           ),
//         ),
//         title: Row(
//           children: [
//             Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: getProportionateScreenWidth(20))),
//             Text("My Post"),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: getProportionateScreenWidth(60)),
//             ),
//             Icon(Icons.search),
//           ],
//         ),
//       ),
//       body: ListView.builder(
//           itemCount: fetchpost!.data!.length,
//           itemBuilder: (context, index) {
//             return Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: getProportionateScreenWidth(20),
//               ),
//               margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color.fromARGB(255, 176, 176, 176),
//                     blurRadius: 5.0,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(fetchpost!.data![index].conditionName.toString()),
//                       Icon(
//                         Icons.more_vert,
//                       )
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         margin:
//                             EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
//                         padding: EdgeInsets.all(30.0),
//                         child: Column(
//                           children: [
//                             Image(
//                               image: fetchpost!.data![index].cover.toString() ==
//                                       "https://dev.get-ug.com/"
//                                   ? const NetworkImage(
//                                       "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png")
//                                   : (fetchpost!.data![index].cover.toString() ==
//                                           "https://dev.get-ug.com/2a879884-8ff3-4f63-9e2e-95afbdecd80a.jpeg"
//                                       ? const NetworkImage(
//                                           "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png")
//                                       : fetchpost!.data![index].cover
//                                                   .toString() ==
//                                               "https://dev.get-ug.com/3900a9fa-a751-45e0-b911-961295eaea85.jpeg"
//                                           ? const NetworkImage(
//                                               "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png")
//                                           : NetworkImage(fetchpost!
//                                               .data![index].cover
//                                               .toString())),
//                               height: 100.0,
//                               width: 100.0,
//                               fit: BoxFit.cover,
//                             )
//                           ],
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               Padding(
//                                   padding: EdgeInsets.symmetric(
//                                 horizontal: getProportionateScreenWidth(20),
//                               )),
//                               Text(
//                                 fetchpost!.data![index].name.toString(),
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                   padding: EdgeInsets.symmetric(
//                                 horizontal: getProportionateScreenWidth(20),
//                               )),
//                               Text(
//                                 fetchpost!.data![index].price.toString(),
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                   Row(),
//                 ],
//               ),
//             );
//           }),
//     );
//   }
// }
