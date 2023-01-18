import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:autolocksmith/FCM/fcm.dart';
import 'package:autolocksmith/Home/dashboard.dart';
import 'package:autolocksmith/Login/Login.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final User user;
  SplashScreen({this.user});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sp;
  FCMConfig fcm = FCMConfig();
  String version = "Version: 1.0";

  @override
  void initState() {
    fcm.initialize(context);
    getSp();
  }

  getSp() async {
    sp = await SharedPreferences.getInstance();
    Timer(
      Duration(milliseconds: 1500),
      () {
        if (sp.containsKey("id")) {
          //
          // shop = await shop.fromSharedPreference();
          User user = User(
            id: sp.getInt('id'),
            personName: sp.getString('person_name'),
          );

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                      // shop: shop,
                      user: user)),
              (route) => false);
          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomePage(// shop: shop,)), (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => Login()), (route) => false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.user != null
          ? Container(
              color: Theme.of(context).primaryColor,
              width: 1.sw,
              height: 1.sh,
              child: Container(
                  color: Colors.grey.shade200,
                  child: Center(child: CircularProgressIndicator())))
          : Stack(
              children: [
                Container(
                    color: Theme.of(context).primaryColor,
                    width: 1.sw,
                    height: 1.sh,
                    child: Container(
                        // color: Colors.grey.shade200,
                        child: Center(
                            child: Image.asset(
                      'asset/startingIcon.png',
                      height: 0.15.sh,
                      width: 0.5.sw,
                      fit: BoxFit.fitHeight,
                    )))),
                Positioned(
                    bottom: 0.05.sh,
                    left: 0,
                    child: Container(
                      width: 1.sw,
                      child: Center(
                          child: Text(
                        "$version",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Theme.of(context).backgroundColor),
                      )),
                    ))
              ],
            ),
    );
  }
}
