import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

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
          AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset("images/icon.png"),
          ),

          // google login button
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                shape: const StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                Routes.instance.pushReplacement(
                    widget: const HomeScreen(), context: context);
              },

              // google icon
              icon: Image.asset(
                "images/google.png",
                height: mq.height * .03,
              ),

              // login with google label
              label: RichText(
                  text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(text: "Login with "),
                  TextSpan(
                    text: "Google",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
