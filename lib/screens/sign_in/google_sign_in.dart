import 'package:flutter/material.dart';
import 'package:getug/models/registerby_google/registerby_google.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInScreen extends StatefulWidget {
  static String routeName = '/google';
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '396051440536-dnrv0119v4vp49lcejd70trb64g4c722.apps.googleusercontent.com',
    clientId:
        '396051440536-dnrv0119v4vp49lcejd70trb64g4c722.apps.googleusercontent.com',
  );
  SharedPreferences? _prefs;
  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToPrefs(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print('Display Name: ${account.displayName}');
        print('Email: ${account.email}');
        // Mobile number is not directly available through Google Sign-In.
        // You may need to use additional APIs to retrieve it.
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignIsn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final googleAuth = await googleSignInAccount.authentication;

        // Make API request to register user with Google credentials
        final registerResponse = await registerByGoogle(
          googleAuth.accessToken ?? '',
          googleSignInAccount.email ?? '',
          googleSignInAccount.displayName ?? '',
          googleSignInAccount.photoUrl ?? '',
        );

        if (registerResponse.status == 'success') {
          // Save user details to SharedPreferences if needed
          await saveToPrefs('email', googleSignInAccount.email ?? '');
          await saveToPrefs(
              'displayName', googleSignInAccount.displayName ?? '');
          await saveToPrefs('photoUrl', googleSignInAccount.photoUrl ?? '');

          // Navigate to another screen after successful registration
          Navigator.pushNamed(
            context,
            HomeScreen.routeName,
          );
        } else {
          // Handle registration failure
          print('Error registering user: ${registerResponse.status}');
        }
      }
    } catch (error) {
      // Handle sign-in failure
      print('Error signing in: $error');
    }
  }

  Future<registerby_google> registerByGoogle(
    String accessToken,
    String email,
    String displayName,
    String photoUrl,
  ) async {
    final apiUrl = "/api/registerbygoogle";
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'accessToken': accessToken,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
      },
    );

    if (response.statusCode == 200) {
      return registerby_google.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register user by Google');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/google.png',
              height: 100,
              width: 100,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _handleSignIn();
              },
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
