import 'dart:io';
import 'dart:math' as math;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:autolocksmith/API/api.dart';
import 'package:autolocksmith/Home/splashscreen.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:autolocksmith/widgets/LoginWidget.dart';
import 'package:autolocksmith/widgets/loader.dart';
import 'package:autolocksmith/widgets/toast.dart';
import 'package:autolocksmith/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pswd = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: LoginWidget(
      container1: Center(
        child: Image.asset("asset/logo.png", width: 0.6.sw),
      ),
      container2: Container(
        width: 0.85.sw,
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40.h,
              ),
              WhiteHeadTextWidget(
                text: "Already a Auto Locksmiths member?",
                fontSize: 25.sp,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(
                height: 0.025.h,
              ),
              WhiteHeadTextWidget(
                text: "Sign in to your control panel",
                fontSize: 20.sp,
                // fontWeight: FontWeight.w800,
              ),
              SizedBox(
                height: 0.02.h,
              ),
              WhiteHeadTextWidget(
                text:
                    "Note: For added security email/password login detail are case sensitive",
                fontSize: 15.sp,
                // fontWeight: FontWeight.w800,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFormFieldWidget(
                label: "",
                controller: _email,
                hint: "Email",
                validate: (value) {
                  if (value == "") {
                    return "This field cannot be empty.";
                  }
                  return null;
                },
                type: TextInputType.emailAddress,
                maxLines: 1,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFormFieldWidget(
                controller: _pswd,
                label: "",
                hint: "Password",
                type: TextInputType.text,
                isPassword: true,
                maxLines: 1,
              ),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_email.text == "") {
                    ShowToast.show(
                      "Enter your email address",
                    );
                  } else if (_pswd.text == "") {
                    ShowToast.show(
                      "Enter your password",
                    );
                  } else {
                    String model = "";
                    if (Platform.isAndroid) {
                      AndroidDeviceInfo androidInfo =
                          await deviceInfo.androidInfo;
                      model = androidInfo.device;
                    }
                    API api = API();
                    FirebaseMessaging fcm = FirebaseMessaging.instance;
                    Loader loader = Loader();
                    if (Platform.isIOS)
                      await FirebaseMessaging.instance.requestPermission();
                    String token = "";

                    // if(Platform.isAndroid)
                    token = await fcm.getToken();
                    // if(Platform.isIOS)
                    // token = await fcm.g
                    // etAPNSToken();
                    var data = {
                      "email": _email.text,
                      "password": _pswd.text,
                      "device": Platform.isIOS ? "iPhone" : model,
                      "fcm": token
                    };
                    debugPrint('$data');
                    loader.showLoader("Please Wait", context);
                    var body = await api.postData("login/", data);

                    loader.hideLoader(context);
                    if (body is String) {
                      ShowToast.show(
                        "$body",
                      );
                    } else {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.setInt('id', body["user_id"]);
                      sp.setString('person_name', body["person_name"]);
                      // Shop shop = Shop.fromMap(body);
                      // shop.toSharedPreference(shop);
                      sp.setString("token", token);
                      sp.setString("jwtToken", body["token"]);
                      if (kDebugMode) print("FCM Token: $token");
                      User user = User(
                        id: sp.getInt('id'),
                        personName: sp.getString('person_name'),
                      );
                      // shop = await shop.fromSharedPreference();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen(user: user)),
                          (route) => false);
                    }
                  }
                },
                child: RaisedGradientButton(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.black,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(0.65, 0.0),
                    // tileMode: TileMode.mirror,begin: Alignment.topLeft,end: Alignment.bottomRight,
                    transform: GradientRotation(math.pi / 2),
                  ),
                  child: Center(
                    child: WhiteHeadTextWidget(
                      text: "Login",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                },
                child: WhiteHeadTextWidget(
                  text: "Forgot Password?",
                  fontSize: 18.sp,
                  // fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

///Forget password
class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginWidget(
        container1: Center(
          child: Image.asset("asset/junkgator_logo.png", width: 0.6.sw),
        ),
        container2: Container(
          width: 1.sw,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                WhiteHeadTextWidget(
                  text: "Recover password",
                  fontSize: 25.h,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(
                  height: 0.025.h,
                ),
                WhiteHeadTextWidget(
                  text:
                      "Don't worry! Enter the email address associated with your Auto Locksmiths"
                      " account and we will send you link so that you can reset your password",
                  fontSize: 15.sp,
                  // fontWeight: FontWeight.w800,
                ),
                SizedBox(
                  height: 25.h,
                ),
                TextFormFieldWidget(
                  controller: _email,
                  label: "",
                  hint: "Email address",
                  type: TextInputType.emailAddress,
                  maxLines: 1,
                  isEnabled: true,
                ),
                SizedBox(
                  height: 25.h,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_email.text == "") {
                      FocusScope.of(context).unfocus();
                      ShowToast.show("Email cannot be blank");
                    } else {
                      FocusScope.of(context).unfocus();
                      API api = API();
                      var body = await api.postData(
                          "recover-password/", {"email": _email.text});
                      print(body is String);
                      if (body is String) {
                        ShowToast.show("Invalid Email address");
                      } else {
                        ShowToast.show(body["message"]);
                      }
                      return Get.off(() => Login());
                    }
                  },
                  child: RaisedGradientButton(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.black,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.65, 0.0),
                      // tileMode: TileMode.mirror,begin: Alignment.topLeft,end: Alignment.bottomRight,
                      transform: GradientRotation(math.pi / 2),
                    ),
                    child: Center(
                        child: WhiteHeadTextWidget(
                      text: "Submit",
                      fontSize: 20.h,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                ),
                SizedBox(height: 0.03.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
