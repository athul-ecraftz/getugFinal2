import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getug/routs.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/splash/splash_screen.dart';
import 'package:getug/theme.dart';
import 'package:provider/provider.dart';
import 'package:getug/signalR.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the ChatProvider

var email;
var password;
var isLoggedIn;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString("email");
  password = prefs.getString("password");
  isLoggedIn = prefs.getBool("isLoggedIn");
  print('Starting SignalR connection...');

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        var chatProvider = SignalRProvider(onMessageReceived: () {});
        chatProvider.initializeSignalR(); // Ensure SignalR is initialized
        return chatProvider;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GET-UG ',
      theme: theme(),
      initialRoute:
          isLoggedIn == true ? HomeScreen.routeName : SplashScreen.routeName,
      routes: routes,
    );
  }
}
