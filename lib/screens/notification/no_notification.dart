import 'package:flutter/material.dart';
import 'package:getug/screens/home/home_screen.dart';

class NoNotification extends StatefulWidget {
  const NoNotification({super.key});

  @override
  State<NoNotification> createState() => _NoNotificationState();
}

class _NoNotificationState extends State<NoNotification> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    // Define your screens or pages here
    HomeScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          children: [
            Text("Notification"),
            Padding(
              padding: EdgeInsets.only(top: 12, right: 150),
            ),
            Icon(Icons.search),
          ],
        ),
      ),
      body: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Notification",
                style: TextStyle(fontSize: 20),
              ),
              Padding(padding: EdgeInsets.only(top: 200))
            ],
          ),
          // Row(
          //   children: [
          //     Image(image: AssetImage("assets/images/notification.jpg"))
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Check Back Here for Updates!"),
              Padding(
                padding: EdgeInsets.only(top: 2),
              ),
            ],
          )
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blue,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
