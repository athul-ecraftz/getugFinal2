import 'package:flutter/material.dart';
import 'package:getug/screens/chat_screen/chat.dart';
import 'package:getug/screens/home/components/body.dart';
import 'package:getug/screens/notification/notification.dart';
import 'package:getug/screens/profile/userprofile.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future getSharedprefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.getString('email');
  //   String email = prefs.getString('email').toString();
  //   print("homescreen $email");
  //   prefs.getString('userid');
  //   String userid = prefs.getString('userid').toString();
  //   print(userid);
  //   print(prefs.getString('email'));
  // }

  int _currentIndex = 0;
  final List<Widget> _tabs = [
    Body(),
    ChatScreen(),
    NotificationScreen(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarHome(
      //   title: const Text.rich(
      //     TextSpan(
      //       children: [
      //         WidgetSpan(
      //           child: Padding(
      //             padding: EdgeInsets.only(right: 50),
      //             child: Icon(Icons.location_on, color: Colors.blue),
      //           ),
      //         ),
      //         TextSpan(
      //             text: 'Location, Uganda', style: TextStyle(fontSize: 16)),
      //       ],
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.pushNamed(context, ProductDetails.routeName);
      //       },
      //       icon: const Icon(Icons.notifications_outlined),
      //       color: Color(0xff2067d2),
      //     ),
      //   ],
      // ),
      // body: _tabs[_currentIndex],

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade100,
          height: 60,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 12,
              fontFamily: 'Arial',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFFf1f5f6),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Image(
                image: const AssetImage('assets/images/home.png'),
                width: (20),
                color: _currentIndex == 0 ? Colors.blue : Colors.grey,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Image(
                image: const AssetImage('assets/images/chat.png'),
                width: (20),
                color: _currentIndex == 1 ? Colors.blue : Colors.grey,
              ),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Image(
                image: const AssetImage('assets/images/announcement.png'),
                width: (20),
                color: _currentIndex == 2 ? Colors.blue : Colors.grey,
              ),
              label: 'Notification',
            ),
            NavigationDestination(
              icon: Image(
                image: const AssetImage('assets/images/user.png'),
                width: (20),
                color: _currentIndex == 3 ? Colors.blue : Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),

      // bottomNavigationBar: Container(
      //   margin: const EdgeInsets.only(
      //     left: 20,
      //     right: 20,
      //   ),
      //   decoration: const BoxDecoration(
      //     color: Colors.yellow,
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(30.0),
      //       topRight: Radius.circular(30.0),
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey,
      //         blurRadius: 5.0,
      //       ),
      //     ],
      //   ),
      //   child: BottomNavigationBar(
      //     selectedItemColor: Colors.red,
      //     unselectedItemColor: Colors.black,
      //     currentIndex: _currentIndex,
      //     onTap: (index) {
      //       setState(() {
      //         _currentIndex = index;
      //       });
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //           icon: Image(
      //             image: const AssetImage('assets/images/home.png'),
      //             width: (20),
      //             color: _currentIndex == 0 ? Colors.blue : Colors.grey,
      //           ),
      //           label: ''),
      //       BottomNavigationBarItem(
      //           icon: Image(
      //             image: const AssetImage('assets/images/chat.png'),
      //             width: (20),
      //             color: _currentIndex == 1 ? Colors.blue : Colors.grey,
      //           ),
      //           label: ''),
      //       BottomNavigationBarItem(
      //           icon: Image(
      //             image: const AssetImage('assets/images/announcement.png'),
      //             width: (20),
      //             color: _currentIndex == 2 ? Colors.blue : Colors.grey,
      //           ),
      //           label: ''),
      //       BottomNavigationBarItem(
      //           icon: Image(
      //             image: const AssetImage('assets/images/user.png'),
      //             width: (20),
      //             color: _currentIndex == 3 ? Colors.blue : Colors.grey,
      //           ),
      //           label: ''),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: BottomAppBar(
      //   // shape: RoundedRectangleBorder(
      //   //   borderRadius: BorderRadius.only(
      //   //     topLeft: Radius.circular(20),
      //   //     topRight: Radius.circular(20),
      //   //   ),
      //   // ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       IconButton(
      //         icon: Icon(Icons.home),
      //         onPressed: () {
      //           // Handle Home button tap
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.message),
      //         onPressed: () {
      //           // Handle Messages button tap
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.notifications),
      //         onPressed: () {
      //           // Handle Notifications button tap
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.person),
      //         onPressed: () {
      //           // Handle Profile button tap
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: const EdgeInsets.all(0),
      //     children: [
      //       UserAccountsDrawerHeader(
      //         accountName: const Text('Afthab K'),
      //         accountEmail: const Text('afthabk@gmail.com'),
      //         currentAccountPicture: CircleAvatar(
      //           child: ClipOval(child: Image.asset('assets/images/user.jpg')),
      //         ),
      //         decoration: const BoxDecoration(color: Colors.blue),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () {
      //           print('Home screen');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.account_circle_outlined),
      //         title: Text('Home'),
      //         onTap: () {
      //           print('Home screen');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () {
      //           print('Home screen');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () {
      //           print('Home screen');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () {
      //           print('Home screen');
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: _tabs[_currentIndex],
      // body: Body(),
    );
  }
}
