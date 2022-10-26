import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:autolocksmith/model/lead_info.dart';
import 'package:autolocksmith/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:autolocksmith/API/api.dart';
import 'package:autolocksmith/FCM/fcm.dart';
import 'package:autolocksmith/Home/changePassword.dart';
import 'package:autolocksmith/Home/leads.dart';
import 'package:autolocksmith/Home/profile.dart';
import 'package:autolocksmith/Login/Login.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:autolocksmith/widgets/DashBoardWidget.dart';
import 'package:autolocksmith/widgets/connectivity.dart';
import 'package:autolocksmith/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage({this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double height, width;
  SharedPreferences sp;
  API api = API();
  Loader loader = Loader();
  bool internet = false;
  Connection connection = Connection();
  int count;
  Lead leadsDetail;
  List<Lead> newLeads = [];
  List<Lead> allLeads = [];
  List<Lead> submittedLeads = [];
  FCMConfig fcm = FCMConfig();
  @override
  void initState() {
    fcm.initialize(context);
    getSp();
  }

  getSp() async {
    sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    if (widget.user.personName == null)
      widget.user = User(
        id: sp.getInt('id'),
        personName: sp.getString('person_name'),
      );
    if (kDebugMode) print("FCM Token: $token");
    leadsDetail = Lead();
    List<Lead> lead = await context.read<Lead>().getLeadsCount(context);
    FlutterAppBadger.updateBadgeCount(allLeads.length);
    setState(() {
      allLeads = lead;
      FlutterAppBadger.updateBadgeCount(allLeads.length);
    });
    if (kDebugMode) print(allLeads.length);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => Lead(),
      child: Consumer<Lead>(builder: (contexts, lead, widges) {
        return DashBoardWidget(
          header: "Dashboard",
          currentPage: "Dashboard",
          user: widget.user,
          container2: Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 80.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Badge(
                    position: BadgePosition.topEnd(top: -5, end: -2),
                    animationDuration: Duration(milliseconds: 100),
                    animationType: BadgeAnimationType.slide,
                    badgeContent: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        allLeads.length.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                    ),
                    child: GestureDetector(
                        onTap: () async {
                          connection.check();
                          if (sp.getBool("internet")) {
                            selectOntap(0, context);
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                                child: Image.asset(
                                  "asset/leads.png",
                                ),
                                width: 0.22.sw),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Text(
                              "Leads",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.035),
                            )
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      selectOntap(1, context);
                    },
                    child: Column(
                      children: [
                        Container(
                            child: Image.asset("asset/profile.png"),
                            width: 0.22.sw),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.035),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectOntap(2, context);
                    },
                    child: Column(
                      children: [
                        Container(
                            child: Image.asset("asset/change_pswd.png"),
                            width: 0.22.sw),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          "Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.035),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      selectOntap(3, context);
                    },
                    child: Column(
                      children: [
                        Container(
                            child: Image.asset("asset/logout.png"),
                            width: 0.22.sw),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.035),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
        );
      }),
    );
  }

  selectOntap(int i, context) async {
    //
    // shop = await shop.fromSharedPreference();

    switch (i) {
      case 0:
        //
        // shop = await shop.fromSharedPreference();
        sp = await SharedPreferences.getInstance();
        DateTime date = DateTime.now();
        newLeads.clear();
        submittedLeads.clear();
        loader.showLoader("Fetching Leads", context);
        var body = await api.getData("leads/");
        if (body == "{}") {
          body = [];
        }
        if (!(body is String)) {
          for (int i = 0; i < body.length; i++) {
            Lead lead = Lead.fromJson(body[i]);
            if (lead.quoteSendAt == "") {
              newLeads.add(lead);
            } else {
              submittedLeads.add(lead);
            }
          }

          await loader.hideLoader(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyLeads(
                      newLeads: newLeads,
                      submittedLeads: submittedLeads,
                      user: widget.user)));
        } else {
          ShowToast.show("Something went wrong \n Try again after sometime");
        }
        break;

      case 1:
        loader.showLoader("Fetching Profile", context);
        var body = await api.getData("profile/");
        await loader.hideLoader(context);
        User user = User.fromJson(body);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyProfile(
                  // shop: shop,
                  user: user,
                )));
        break;

      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangePassword(
                  // shop: shop,
                  user: widget.user,
                )));
        break;

      case 3:
        await FirebaseMessaging.instance.deleteToken();
        sp.clear();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
        break;
    }
  }
}
