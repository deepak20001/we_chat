import 'package:flutter/material.dart';

class Routes {
  static Routes instance = Routes();
  
  Future<dynamic> push(
      {required Widget widget, required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => widget),
    );
  }

  Future<dynamic> pushReplacement(
      {required Widget widget, required BuildContext context}) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) => widget),
    );
  }
}
