

import 'dart:convert';
import 'package:autolocksmith/Home/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autolocksmith/API/api.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:autolocksmith/widgets/DashBoardWidget.dart';
import 'package:autolocksmith/widgets/toast.dart';
import 'package:autolocksmith/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ChangePassword extends StatefulWidget {
  final Shop shop;
  ChangePassword({this.shop});
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _cnfPassword = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  API api = API();
  Shop shop = Shop();
  @override
  void initState() {
  // TODO: implement initState
  super.initState();
  getSp();
  }

  @override
  void dispose() {
    super.dispose();
    _oldPassword.dispose();
    _newPassword.dispose();
    _cnfPassword.dispose();
  }

  getSp()async{
    Shop sh = Shop();
    sh = await shop.fromSharedPreference();
    setState((){
      shop = sh;
    });
  }


  @override
  Widget build(BuildContext context) {
    return DashBoardWidget(
      header: "Change Password",
      currentPage: "ChangePassword",
      shop: shop,
      container2: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.08.sw,vertical: 0.03.sh),
        child: Form(
          key: key,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
              ),
              TextFormFieldWidget(
                hint: "Old Password",
                controller: _oldPassword,
                isPassword: true,
                maxLines: 1,
                validate: (value){
                  if(value == "")
                  {
                    // ShowToast.show("This field cannot be blank", context);
                    return "This field cannot be blank";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFormFieldWidget(

                hint: "New Password",
                maxLines: 1,
                isPassword: true,
                controller: _newPassword,
                validate: (value){
                  if(value == "")
                  {
                    // ShowToast.show("This field cannot be blank", context);
                    return "This field cannot be blank";
                  }
                  if(value!=_cnfPassword.text){
                    return "Password does not matched";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFormFieldWidget(
                hint: "Confirm Password",
                controller: _cnfPassword,
                isPassword: true,
                maxLines: 1,
                validate: (value){
                  if(value!=_newPassword.text){
                    return "Password does not matched";
                  }
                  if(value == "")
                  {
                    return "This field cannot be blank";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: ()async{
                  FocusScope.of(context).unfocus();
                  if(key.currentState.validate()) {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    var res = await api.postData(
                        "resetpass.php?resetpass=resetpass&shop_email=${sp.getString("shopEmail")}&shop_password=${_oldPassword.text}&&shop_password_new=${_newPassword.text}&shop_id=${sp.getString("id")}");
                    var body = jsonDecode(res.body);
                    if(body["status"] == "success")
                    {
                      ShowToast.show("Password changed successfully", context);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(shop: widget.shop,)), (route) => false);
                    }
                    else{
                      ShowToast.show("Failed to change password", context);
                    }
                  }
                },
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0.035.sw),
                    child: Center(
                      child: Text("Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp
                        ),),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),



    );
  }
}
