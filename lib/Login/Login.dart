import 'dart:convert';
import 'dart:math' as math;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autolocksmith/API/api.dart';
import 'package:autolocksmith/Home/splashscreen.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:autolocksmith/widgets/LoginWidget.dart';
import 'package:autolocksmith/widgets/loader.dart';
import 'package:autolocksmith/widgets/toast.dart';
import 'package:autolocksmith/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _email = TextEditingController();
  TextEditingController _pswd = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginWidget(
        container1: Center(
          child: Image.asset("asset/logo.png",width: 0.6.sw),
        ),
        container2: Container(
          width: 0.85.sw,
          child: Form(
            key:key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40.h,),
                WhiteHeadTextWidget(text:"Already an Auto Locksmiths member?",
                fontSize: 25.sp,
                fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 0.025.h,),
                WhiteHeadTextWidget(text:"Sign in to your control panel",
                fontSize: 20.sp,
                // fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 0.02.h,),
                WhiteHeadTextWidget(text:"Note: For added security email/password login detail are case sensitive",
                fontSize: 15.sp,
                // fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 20.h,),
                TextFormFieldWidget(
                  label: "",
                  controller: _email,
                  hint: "Email",
                  validate: (value){
                    if(value == ""){
                      return "This field cannot be empty.";
                    }
                    return null;
                  },
                  type: TextInputType.emailAddress,
maxLines: 1,
                ),
                SizedBox(height: 10.h,),
                TextFormFieldWidget(
                  controller: _pswd,
                  label: "",
                  hint: "Password",
                  type: TextInputType.text,
                  isPassword: true,
                  maxLines: 1,

                ),
                SizedBox(height: 10.h,),
                GestureDetector(
                  onTap: ()async{
                    FocusScope.of(context).requestFocus(FocusNode());
                    if(_email.text == "") {
                      Toast.show("Enter your email", context);
                    }
                    else if(_pswd.text == ""){
                      Toast.show("Enter your password", context);
                    }
                    else{
                      API api = API();
                      FirebaseMessaging fcm = FirebaseMessaging.instance;
                      Loader loader = Loader();
                      String token = await fcm.getToken();
                      loader.showLoader("Please Wait",context);
                      var res = await api.postData(
                          "applogin.php?login=submit&shop_email=${_email.text}&shop_password=${_pswd.text}&token=$token");
                      var body = jsonDecode(res.body);
                      loader.hideLoader(context);
                      if (body["status"] == "success") {
                        SharedPreferences sp = await SharedPreferences.getInstance();
                        Shop shop = Shop.fromMap(body);
                        shop.toSharedPreference(shop);
                        sp.setString("token", token);
                        print("FCM Token: $token");
                        shop = await shop.fromSharedPreference();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashScreen(
                                      shop: shop,
                                    )),
                            (route) => false);
                      }
                      else {
                        Toast.show("Invalid Credentials", context);
                      }
                    }
                  },
                  child: RaisedGradientButton(
                    gradient: LinearGradient(colors: [Colors.white,Colors.black,],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.65, 0.0),
                        // tileMode: TileMode.mirror,begin: Alignment.topLeft,end: Alignment.bottomRight,
                    transform:  GradientRotation(math.pi /2),
                    ), child: Center(
                    child: WhiteHeadTextWidget(
                      text: "Login",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,)
                    ,)
                    ,
                  ),
                ),
                SizedBox(height: 15.h),
                GestureDetector(
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()
                    ));
                  },
                  child: WhiteHeadTextWidget(
                    text:"Forgot Password?",
                    fontSize: 18.sp,
                    // fontWeight: FontWeight.w800,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
          child: Image.asset("asset/logo.png",width: 0.6.sw),
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
                SizedBox(height: 50.h,),
                WhiteHeadTextWidget(text:"Recover password",
                  fontSize: 25.h,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 0.025.h,),
                WhiteHeadTextWidget(text:"Don't worry! Enter the email address associated with your Auto Locksmiths"
                    " account and we will send you link so that you can reset your password",
                  fontSize: 15.sp,
                  // fontWeight: FontWeight.w800,
                ),

                SizedBox(height: 25.h,),
                TextFormFieldWidget(
                  controller: _email,
                  label: "",
                  hint: "Email address",
                  type: TextInputType.emailAddress,
                  maxLines: 1,
                  isEnabled: true,
                ),
                SizedBox(height: 25.h,),
                GestureDetector(
                  onTap: ()async{



                    if(_email.text == "") {
                        FocusScope.of(context).unfocus();
                        ShowToast.show("Email cannot be blank", context);
                      }
                      else{
                      FocusScope.of(context).unfocus();
                      API api = API();
                      var res = await api
                          .postData("forgotpass.php?action=sendemail&cont_email=${_email.text}");
                      var body = jsonDecode(res.body);
                      if(body["status"] == "success"){

                        ShowToast.show("Please check E-mail", context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      }else{
                        ShowToast.show("Invalid E-mail.", context);
                      }
                    }
                  },
                  child: RaisedGradientButton(
                    gradient: LinearGradient(colors: [Colors.white,Colors.black,],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.65, 0.0),
                      // tileMode: TileMode.mirror,begin: Alignment.topLeft,end: Alignment.bottomRight,
                      transform:  GradientRotation(math.pi /2),
                    ), child: Center(
                    child: WhiteHeadTextWidget(
                      text: "Submit",fontSize: 20.h,fontWeight: FontWeight.w600,)),
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
