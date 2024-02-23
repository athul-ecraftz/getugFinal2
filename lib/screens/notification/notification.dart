import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/update_notification/update_notification.dart';
import 'package:getug/screens/home/home_screen.dart';

import 'dart:convert' as convert;

class NotificationScreen extends StatefulWidget {
  static String routeName = '/notification';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

// Future<update_notification> notification() async {
//   var response =
//       await getJson("/api/getAllNotificationforUser?userId=32&limit=10");
//   update_notification? cat;
//   Data? d;
//   print(response.toString());
//   if (response.statusCode == 200) {
//     // print(response);
//     var jsonResponse =
//         convert.jsonDecode(response.body) as Map<String, dynamic>;
//     var itemCount = jsonResponse['data'];
//     print(jsonResponse);
//     cat = update_notification.fromJson(jsonResponse);
//     // dataresponse = jsonResponse['data'];
//     // print('Number of books about http: $itemCount.');
//   } else if (response.statusCode == 400) {
//     var jsonResponse =
//         convert.jsonDecode(response.body) as Map<String, dynamic>;
//     var itemCount = jsonResponse['data'];
//     cat = update_notification.fromJson(jsonResponse);
//     //print(user);
//   } else {
//     print('Request failed with status: ${response.statusCode}.');
//   }

//   return cat!;
// }

class _NotificationScreenState extends State<NotificationScreen> {
  int _currentIndex = 0;

  // final List<Widget> _tabs = [
  //   HomeScreen(),
  //   profileScreen(),
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification", style: TextStyle(fontSize: 21)),
      ),

      body: SafeArea(
        child: ListView(
          children: [
            for (int i = 1; i < 5; i++)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: Image.asset(
                        'assets/images/profile.png',
                        height: 90,
                        width: 90,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        "View More Notifications",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 130),
                      child: Icon(
                        Icons.more_vert,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.blue,
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.message),
      //       label: 'Message',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.campaign),
      //       label: 'Notification',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}
