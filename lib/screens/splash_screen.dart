import 'dart:developer';
import 'package:chat_app/constants/assets_path.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_constants.dart';
import '../api/apis.dart';
import '../constants/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      // exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
      ));

      if (APIs.auth.currentUser != null) {
        log("\nUser: ${APIs.auth.currentUser}");

        // navigate to home screen
        Routes.instance
            .pushReplacement(widget: const HomeScreen(), context: context);
      } else {
        // navigate to login screen
        Routes.instance
            .pushReplacement(widget: const LoginScreen(), context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      // app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome to We Chat"),
      ),

      // body
      body: Stack(
        children: [
          // app logo
          Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset(AssetsIcons.instance.appIcon),
          ),

          // google login button
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text(
              "MADE IN INDIA WITH ❤️",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
