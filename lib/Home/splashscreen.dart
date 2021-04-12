import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autolocksmith/FCM/fcm.dart';
import 'package:autolocksmith/Home/dashboard.dart';
import 'package:autolocksmith/Login/Login.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final Shop shop;
  SplashScreen({this.shop});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SharedPreferences sp;
  FCMConfig fcm = FCMConfig();
  @override
  void initState() {
    fcm.initialize(context);
    getSp();
  }

  getSp()async{
      sp = await SharedPreferences.getInstance();
      if(sp.containsKey("id"))
      {
       Shop shop =Shop();
        shop = await shop.fromSharedPreference();
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => HomePage(shop: shop,)),(route) => false);
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomePage(shop: shop,)), (route) => false);
      }
      else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => Login()), (route) => false);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child:Container(
            color: Colors.grey.shade200,
            child: Center(child: CircularProgressIndicator()))
      ),
    );
  }
}
