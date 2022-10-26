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
  User user;
  ChangePassword({this.user});
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _cnfPassword = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  API api = API();
  //
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

  getSp() async {
    // Shop sh = Shop();
    // sh = await user.fromSharedPreference();
    // setState(() {
    //   user = sh;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DashBoardWidget(
      header: "Password",
      currentPage: "ChangePassword",
      user: widget.user,
      container2: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.08.sw, vertical: 0.03.sh),
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
                hint: "Old password",
                controller: _oldPassword,
                isPassword: true,
                maxLines: 1,
                validate: (value) {
                  if (value == "") {
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
                hint: "New password",
                maxLines: 1,
                isPassword: true,
                controller: _newPassword,
                validate: (value) {
                  if (value == "") {
                    // ShowToast.show("This field cannot be blank", context);
                    return "This field cannot be blank";
                  }
                  if (value != _cnfPassword.text) {
                    return "Password does not matched";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFormFieldWidget(
                hint: "Confirm new password",
                controller: _cnfPassword,
                isPassword: true,
                maxLines: 1,
                validate: (value) {
                  if (value != _newPassword.text) {
                    return "Password does not matched";
                  }
                  if (value == "") {
                    return "This field cannot be blank";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (key.currentState.validate()) {
                    var data = {
                      "old_password": _oldPassword.text,
                      "new_password": _newPassword.text,
                      "confirm_new_password": _cnfPassword.text
                    };
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    var body = await api.putData("changepassword/", data);

                    if (!(body is String)) {
                      ShowToast.show("Password changed successfully");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    user: widget.user,
                                  )),
                          (route) => false);
                    } else {
                      ShowToast.show("Failed to change password");
                    }
                  }
                },
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.all(0.035.sw),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp),
                      ),
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
