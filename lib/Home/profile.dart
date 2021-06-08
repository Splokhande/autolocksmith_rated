

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autolocksmith/FCM/fcm.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:autolocksmith/widgets/DashBoardWidget.dart';
import 'package:autolocksmith/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProfile extends StatefulWidget {
  final Shop shop;
  MyProfile({this.shop});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  double widthS, heightS;


  FCMConfig fcm = FCMConfig();
  @override
  void initState() {
    fcm.initialize(context);
  }

  @override
  Widget build(BuildContext context) {

    widthS = 20.sw;
    heightS = 15.h;
    return DashBoardWidget(
      header: "My Profile",
      currentPage: "Profile",
      shop: widget.shop,
      container2: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
          child: Column(
            children: [
              Container(
                height: 10.h,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30.h,),
                      ProfileTextFieldWidget(title: "Contact Person",subtitle: widget.shop.shopContactPerson,),
                    SizedBox(height: heightS,),
                      ProfileTextFieldWidget(title: "Buisness Name",subtitle: widget.shop.shopName),
                    SizedBox(height: heightS,),
                      ProfileTextFieldWidget(title: "Address",subtitle: widget.shop.shopAddress ),
                    SizedBox(height: heightS,),
                      ProfileTextFieldWidget(title: "Enquiries within radius",subtitle: widget.shop.shopRadius),
                    SizedBox(height: heightS,),
                      ProfileTextFieldWidget(title: "Telephone No.",subtitle: widget.shop.secondaryTel != "" ? "${widget.shop.shopTelephone} / ${widget.shop.secondaryTel}":"${widget.shop.shopTelephone}" ),
                    SizedBox(height: heightS,),
                      ProfileTextFieldWidget(title: "Website Address:",subtitle: widget.shop.shopWebsite),
                    SizedBox(height: heightS,),
                      ProfileTextFieldWidget(title: "Manager",subtitle: widget.shop.manager),
                    SizedBox(height: heightS,),
                      ProfileTextFieldWidget(title: "Email",subtitle: widget.shop.shopEmail),

                    SizedBox(height: 0.025.sh,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Need to amend your contact details?",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 15.sp),),
                        SizedBox(height: heightS,),
                        widget.shop.country != "United Kingdom"?
                        Text("Call "+"(646) 751-7835",
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 15.sp, color: Colors.blue)
                        ):Text("Call "+"0161 641 4374",
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 15.sp, color: Colors.blue)
                        ),
                        SizedBox(height: 30.h,),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
