import 'package:flutter/material.dart';
import 'package:getug/screens/Enquiry/enquiry.dart';
import 'package:getug/screens/chat_screen/chat_page.dart';
import 'package:getug/screens/forgot_password/components/forgot_otp.dart';
import 'package:getug/screens/forgot_password/components/forgot_password_final.dart';
import 'package:getug/screens/forgot_password/forgot_password_screen.dart';
import 'package:getug/screens/home/components/product_new.dart';
import 'package:getug/screens/home/components/user_location.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/notification/notification.dart';

import 'package:getug/screens/products/category_final.dart';
import 'package:getug/screens/products/favourite.dart';

import 'package:getug/screens/products/mypost.dart';
import 'package:getug/screens/products/mypost_edit.dart';
import 'package:getug/screens/products/post_products.dart';
import 'package:getug/screens/products/product_details.dart';
import 'package:getug/screens/products/product_image.dart';
import 'package:getug/screens/products/related_products.dart';
import 'package:getug/screens/products/update_post.dart';

import 'package:getug/screens/profile/profile_edit.dart';
import 'package:getug/screens/sign_in/google_sign_in.dart';
import 'package:getug/screens/sign_up/components/sign_up_final.dart';
import 'package:getug/screens/sign_up/sign_up_otp.dart';
import 'package:getug/screens/splash/splash_screen.dart';
import 'package:getug/screens/sign_in/sign_in_screen.dart';
import 'package:getug/screens/sign_up/sign_up_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  SignUpOTPVerify.routeName: (context) => const SignUpOTPVerify(),
  SignUpFinal.routeName: (context) => const SignUpFinal(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  ForgotPasswordFinal.routeName: (context) => const ForgotPasswordFinal(),
  CategoryFinal.routeName: (context) => CategoryFinal(),
  ForgotPasswordOTPVerify.routeName: (context) => ForgotPasswordOTPVerify(),
  ProductDetails.routeName: (context) => ProductDetails(),
  EditProfile.routeName: (context) => const EditProfile(),
  MyPost.routeName: (context) => MyPost(),
  ProductPost.routeName: (context) => ProductPost(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
  EnquiryPage.routeName: (context) => EnquiryPage(),
  FavouriteItems.routeName: (context) => FavouriteItems(),
  ChatPage.routeName: (context) => ChatPage(),
  productImage.routeName: (context) => productImage(),
  GoogleSignInScreen.routeName: (context) => GoogleSignInScreen(),
  NewProduct.routeName: (context) => NewProduct(),
  MyApp1.routeName: (context) => MyApp1(),
  MypostEdit.routeName: (context) => MypostEdit(),
};

mixin routeName {}
