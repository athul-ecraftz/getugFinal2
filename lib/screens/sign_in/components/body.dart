import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/components/no_account_text.dart';
import 'package:getug/components/social_card.dart';
import 'package:getug/models/registerby_google/registerby_google.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/sign_in/components/signform.dart';
import 'package:getug/screens/sign_in/google_sign_in.dart';
import 'package:getug/size_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['email'],
  //   clientId:
  //       '396051440536-dnrv0119v4vp49lcejd70trb64g4c722.apps.googleusercontent.com',
  // );

  // Future<void> handleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await _googleSignIn.signIn();
  //     if (googleSignInAccount != null) {
  //       final googleAuth = await googleSignInAccount.authentication;
  //       final authHeaders = await googleSignInAccount.authHeaders;

  //       // Save obtained credentials to SharedPreferences
  //       await saveToPrefs('email', googleSignInAccount.email ?? '');
  //       await saveToPrefs('displayName', googleSignInAccount.displayName ?? '');
  //       await saveToPrefs('photoUrl', googleSignInAccount.photoUrl ?? '');

  //       // Navigate to another screen or perform actions after successful sign-in
  //       // Example:
  //       print("sdkjg");
  //       Navigator.pushNamed(
  //         context,
  //         HomeScreen.routeName,
  //       );
  //     }
  //   } catch (error) {
  //     // Handle sign-in failure
  //     print('Error signing in: $error');
  //   }
  // }

  Future<void> handleSignIn() async {
    print('Login clicked');
    GoogleSignIn _googleSignIn = GoogleSignIn();
    // try {
    //   var result = await _googleSignIn.signIn();
    //   print(result);
    // } catch (e) {
    //   print(e);
    // }

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        print(googleSignInAccount);
        // final googleAuth = await googleSignInAccount.authentication;
        // final authHeaders = await googleSignInAccount.authHeaders;

        String email = googleSignInAccount.email ?? '';
        String photo = googleSignInAccount.photoUrl ?? '';
        String userName = googleSignInAccount.displayName ?? '';

        registerby_google loginDetails = await registerbygoogle(
            email: email, photo: photo, username: userName);

        // print(loginDetails.user.toString());

        if (loginDetails.user != null) {
          print('login details');
          print(loginDetails.user?.email);

          await saveToPrefs('email', loginDetails.user?.email ?? '');
          await saveToPrefs(
              'userid', loginDetails.user?.userId.toString() ?? '');
          await saveToPrefs('firstName', loginDetails.user?.firstName ?? '');
          await saveToPrefs('lastName', loginDetails.user?.lastName ?? '');
          await saveToPrefs(
              'mobileNumber', loginDetails.user?.mobileNumber.toString() ?? '');
          await saveToPrefs('alternateNumber',
              loginDetails.user?.alternateNumber.toString() ?? '');
          await saveToPrefs('photo', loginDetails.user?.photo ?? '');
          await saveToPrefs(
              'description', loginDetails.user?.description ?? '');
          await saveToPrefs1('isLoggedIn', true);
          await saveToPrefs1('loginWithGoogle', true);

          // print(u.toJson());
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName, (Route<dynamic> route) => false);
          // print('test');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong"),
            margin: EdgeInsets.all(10.0),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ));
        }
      }
    } catch (error) {
      // Handle sign-in failure
      print('Error signing in1: $error');
    }
  }

  Future<registerby_google> registerbygoogle(
      {required String email,
      required String photo,
      required String username}) async {
    Map<String, dynamic> data = {
      "userName": "$username",
      "Photo": "$photo",
      "email": "$email",
      "EmailVerified": true,
    };
    registerby_google? user;
    var response = await postJson2("/api/registerbygoogle", data);

    if (response.statusCode == 200) {
      // print(response);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['user'];
      user = registerby_google.fromJson(jsonResponse);
      // print('Number of books about http: $itemCount.');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      jsonResponse['user'] = {};
      user = registerby_google.fromJson(jsonResponse);
      // print(user);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return user!;
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToPrefs(String key, dynamic value) async {
    await _prefs?.setString(key, value);
  }

  Future<void> saveToPrefs1(String key, dynamic value) async {
    await _prefs?.setBool(key, value);
  }

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: SizeConfig.screenHeight! * 0.04,
              ),
              Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(28),
                ),
              ),
              const Text(
                "Sign In with your email and password \n or continue with social media",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.08,
              ),
              SignForm(),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.08,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      handleSignIn();
                    },
                    child: Text(
                      "Sign In With Google",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(15),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SocialCard(
                    icon: "assets/icons/google.svg",
                    press: handleSignIn,
                  ),

                  // SocialCard(
                  //   icon: "assets/icons/facebook.svg",
                  //   press: () {},
                  // ),
                  // SocialCard(
                  //   icon: "assets/icons/twitter.svg",
                  //   press: () {},
                  // ),
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              const NoAccountText()
            ]),
          ),
        ),
      ),
    );
  }
}
