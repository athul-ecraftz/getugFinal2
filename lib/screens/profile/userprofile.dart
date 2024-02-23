import 'package:flutter/material.dart';
import 'package:getug/screens/Enquiry/enquiry.dart';
import 'package:getug/screens/products/favourite.dart';
import 'package:getug/screens/products/mypost.dart';
import 'package:getug/screens/products/post_products.dart';
import 'package:getug/screens/profile/profile_edit.dart';
import 'package:getug/screens/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with WidgetsBindingObserver {
  String email = "";
  String firstName = "";
  String mobileNumber = "";
  String photo = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userdetails();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    userdetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  leading: Icon(Icons.arrow_back_ios),
        title: Text("My Profile", style: TextStyle(fontSize: 21)),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(90.0),
                    child: getImageWidget('$photo'),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$firstName',
                        style: const TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone_android_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '$mobileNumber',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '$email',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()));
              },
              child: const Text(
                "View & Edit Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, FavouriteItems.routeName);
                      },
                      leading: Icon(Icons.favorite_border_outlined),
                      title: Text(
                        "Wishlist",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "Product Wishlist",
                      ),
                      // trailing: IconButton(Icons.arrow_forward_ios_sharp),
                      trailing: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, ProductPost.routeName);
                      },
                      leading: Icon(Icons.credit_card),
                      title: Text(
                        "Post Product",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "Product Posting",
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, MyPost.routeName);
                      },
                      leading: Icon(Icons.shopping_cart),
                      title: Text(
                        "My Post",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "Posted Products",
                      ),
                      // trailing: IconButton(Icons.arrow_forward_ios_sharp),
                      trailing: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, EnquiryPage.routeName);
                      },
                      leading: Icon(Icons.message),
                      title: Text(
                        "Enquiry",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "Enquire For More Details",
                      ),
                      // trailing: IconButton(Icons.arrow_forward_ios_sharp),
                      trailing: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                    ListTile(
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        await preferences.clear();
                        Navigator.of(context).pushNamed(SplashScreen.routeName);
                      },
                      leading: Icon(Icons.logout_outlined),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "Logout",
                      ),
                      // trailing:  Icon(Icons.arrow_forward_ios_sharp),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> userdetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? "";
      firstName = prefs.getString('firstName') ?? "";
      photo = prefs.getString('photo') ?? "";
      mobileNumber = prefs.getString('mobileNumber') ?? "";
    });
    // prefs.getString('email');
    // String email = prefs.getString('email').toString();
    // print(email);
    // prefs.getString('firstName');
    // String firstName = prefs.getString('firstName').toString();
    // print(firstName);
  }

  Widget getImageWidget(String photo) {
    if (photo != '') {
      return Image.network(
        photo,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/images/admin.jpg', // Replace 'default_image.png' with your asset image path
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    }
  }
}
