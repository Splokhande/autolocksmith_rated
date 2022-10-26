import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autolocksmith/FCM/fcm.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:autolocksmith/widgets/DashBoardWidget.dart';
import 'package:autolocksmith/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfile extends StatefulWidget {
  final User user;
  MyProfile({this.user});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  double widthS, heightS;

  Future<void> _launched;
  FCMConfig fcm = FCMConfig();
  @override
  void initState() {
    fcm.initialize(context);
  }

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    widthS = 20.sw;
    heightS = 15.h;
    return DashBoardWidget(
      header: "My Profile",
      currentPage: "Profile",
      user: widget.user,
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
                    SizedBox(
                      height: 30.h,
                    ),
                    ProfileTextFieldWidget(
                      title: "Contact:",
                      subtitle: widget.user.personName,
                    ),
                    SizedBox(
                      height: heightS,
                    ),
                    ProfileTextFieldWidget(
                        title: "Business:", subtitle: widget.user.businessName),
                    SizedBox(
                      height: heightS,
                    ),
                    ProfileTextFieldWidget(
                        title: "Address:", subtitle: widget.user.address),
                    SizedBox(
                      height: heightS,
                    ),
                    ProfileTextFieldWidget(
                        title: "Radius:",
                        subtitle: "${widget.user.radiusMiles} miles"),
                    SizedBox(
                      height: heightS,
                    ),
                    ProfileTextFieldWidget(
                        title: "Telephone:",
                        subtitle: widget.user.secondaryTelephoneNo != null
                            ? "${widget.user.telephoneNo} / ${widget.user.secondaryTelephoneNo}"
                            : "${widget.user.telephoneNo}"),
                    SizedBox(
                      height: heightS,
                    ),
                    ProfileTextFieldWidget(
                        title: "Website:", subtitle: widget.user.website),
                    SizedBox(
                      height: heightS,
                    ),
                    ProfileTextFieldWidget(
                        title: "Manager:", subtitle: widget.user.managerName),
                    SizedBox(
                      height: heightS,
                    ),
                    ProfileTextFieldWidget(
                        title: "Email:", subtitle: widget.user.email),
                    SizedBox(
                      height: 0.025.sh,
                    ),
                    InkWell(
                      onTap: () {
                        _launched = _openUrl('tel: 0161 641 4374');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Need to amend your contact details?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.sp),
                          ),
                          SizedBox(
                            height: heightS,
                          ),
                          Text(" Call (646) 751 7835",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.blue)),
                          SizedBox(
                            height: 30.h,
                          ),
                        ],
                      ),
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
