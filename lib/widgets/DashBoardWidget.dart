import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rated_locksmith/Home/dashboard.dart';
import 'package:rated_locksmith/model/lead_info.dart';
import 'package:provider/provider.dart';
import 'package:rated_locksmith/API/api.dart';
import 'package:rated_locksmith/Home/changePassword.dart';
import 'package:rated_locksmith/Home/leads.dart';
import 'package:rated_locksmith/Home/profile.dart';
import 'package:rated_locksmith/Login/Login.dart';
import 'package:rated_locksmith/model/User.dart';
import 'package:flutter/material.dart';
import 'package:rated_locksmith/model/leads.dart';
import 'package:rated_locksmith/widgets/connectivity.dart';
import 'package:rated_locksmith/widgets/loader.dart';
import 'package:rated_locksmith/widgets/toast.dart';
import 'package:rated_locksmith/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardWidget extends StatelessWidget {
  final Widget? container1;
  final Widget? container2;
  final Widget? widget;
  final String? header;
  final User? user;
  final int? onTap;
  final String? onWill;
  final String? currentPage;
  DashBoardWidget(
      {this.onWill,
      this.container1,
      this.container2,
      this.user,
      this.widget,
      this.header,
      this.currentPage,
      // this.shop,
      this.onTap});
  double height = 0, width = 0;
  List<Lead> newLeads = [];
  List<Lead> submittedLeads = [];
  API api = API();
  Loader loader = Loader();
  TextStyle textStyle = TextStyle(color: Color(0xffe30613));
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (currentPage == "Dashboard") {
            exit(0);
          }
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            elevation: 0,
            leading: ModalRoute.of(context)?.canPop == true
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 0.04.sh,
                    ),
                    onPressed: () {
                      // if(currentPage == null){
                      //   Navigator.of(context).pop();
                      // }
                      // else{
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    // shop: shop,
                                    user: user!,
                                  )),
                          (route) => false);
                      // }
                    },
                  )
                : null,
            shadowColor: Theme.of(context).primaryColor,
            toolbarHeight: 0.075.sh,
            titleSpacing: 20,
            title: WhiteHeadTextWidget(
              text: header ?? "",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          endDrawer: Drawer(
            elevation: 10,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.0),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.background,
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.015,
                        ),
                        child: Text(
                          "Hello ${user!.personName}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: width * 0.045,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (currentPage != "Dashboard") {
                          onTap ?? selectOntap(0, context);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: DrawerItems(
                        text: "Dashboard",
                        isOpen: currentPage == "Dashboard",
                      )),
                  Divider(
                    color: Colors.grey,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (currentPage != "Leads") {
                          onTap ?? selectOntap(1, context);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: DrawerItems(
                        text: "Leads",
                        isOpen: currentPage == "Leads",
                      )),
                  Divider(
                    color: Colors.grey,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (currentPage != "Profile") {
                          onTap ?? selectOntap(2, context);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: DrawerItems(
                        text: "Profile",
                        isOpen: currentPage == "Profile",
                      )),
                  Divider(
                    color: Colors.grey,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (currentPage != "ChangePassword") {
                          onTap ?? selectOntap(3, context);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: DrawerItems(
                        text: "Password",
                        isOpen: currentPage == "ChangePassword",
                      )),
                  Divider(
                    color: Colors.grey,
                  ),
                  GestureDetector(
                      onTap: () {
                        onTap ?? selectOntap(4, context);
                      },
                      child: DrawerItems(
                        text: "Logout",
                        isOpen: false,
                      )),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          body: ChangeNotifierProvider(
            create: (_) => LeadsDetail(),
            child: Consumer<LeadsDetail>(builder: (context, lead, widges) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 2.h,
                    width: width,
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                  ),
                  Expanded(
                    child: Container(
                      height: 681.h,
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 10.h,
                            ),
                            Expanded(child: container2 ?? SizedBox()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  selectOntap(int i, context) async {
    Connection connection = Connection();
    Navigator.of(context).pop();
    SharedPreferences sp = await SharedPreferences.getInstance();
    await connection.check();
    switch (i) {
      case 0:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      // shop: shop,
                      user: user!,
                    )),
            (route) => false);
        break;

      case 1:
        if (sp.getBool("internet") ?? false) {
          loader.showLoader("Fetching Leads", context);
          var body = await api.getData("leads/");
          if (body == "{}") {
            body = [];
          }
          // if(body["leads"].length >0 ) {
          for (int i = 0; i < body.length; i++) {
            Lead lead = Lead.fromJson(body[i]);
            if (lead.quoteSendAt == "") {
              newLeads.add(lead);
            } else {
              submittedLeads.add(lead);
            }
          }
          loader.hideLoader(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyLeads(
                        newLeads: newLeads,
                        submittedLeads: submittedLeads,
                        // shop: shop
                        user: user!,
                      )));
          // }
          // else{
          //   ShowToast.show("No leads to display", context);
          // }
        } else {
          ShowToast.show("No Internet Connection");
        }
        break;

      case 2:
        loader.showLoader("Fetching Profile", context);
        var body = await api.getData("profile/");
        await loader.hideLoader(context);
        User user = User.fromJson(body);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyProfile(
                  // shop: shop,
                  user: user!,
                )));
        break;

      case 3:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangePassword(
                  // shop: shop,
                  user: user!,
                )));
        break;

      case 4:
        await FirebaseMessaging.instance.deleteToken();
        sp.clear();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
        break;
    }
  }
}

class LeadBoardWidget extends StatelessWidget {
  final Widget? container2;
  final Widget? widget;
  final String? header;
  final User? user;
  Function? onTap;
  final String? currentPage;
  LeadBoardWidget(
      {this.container2,
      this.currentPage,
      this.widget,
      this.header,
      this.user,
      this.onTap});
  double height = 0, width = 0;
  List<Lead> newLeads = [];
  List<Lead> submittedLeads = [];
  API api = API();
  Loader loader = Loader();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => LeadsDetail(),
      child: Consumer<LeadsDetail>(builder: (context, lead, widges) {
        return SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            user: user!,
                          )),
                  (route) => false);
              return Future.value(true);
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
                leading: ModalRoute.of(context)?.canPop == true
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 0.035.sh,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        // shop: shop,
                                        user: user!,
                                      )),
                              (route) => false);
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 0.035.sh,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        // shop: shop,
                                        user: user!,
                                      )),
                              (route) => false);
                        },
                      ),
                shadowColor: Theme.of(context).primaryColor,
                toolbarHeight: 0.130.sh,
                title: WhiteHeadTextWidget(
                  text: header ?? "",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                bottom: PreferredSize(
                  preferredSize: Size(width, 0.015.sh),
                  child: widget == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Container(width: 0.9.sw, child: widget),
                        ),
                ),
              ),
              endDrawer: Drawer(
                elevation: 10,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.0),
                        child: ListTile(
                          tileColor: Theme.of(context).backgroundColor,
                          title: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.015,
                            ),
                            child: Text(
                              "Hello ${user!.personName}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_sharp,
                              size: width * 0.045,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (currentPage != "Dashboard") {
                              onTap ?? selectOntap(0, context);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: DrawerItems(
                            text: "Dashboard",
                            isOpen: currentPage == "Dashboard",
                          )),
                      Divider(
                        color: Colors.grey,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (currentPage != "Leads") {
                              onTap ?? selectOntap(1, context);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: DrawerItems(
                            text: "Leads",
                            isOpen: currentPage == "Leads",
                          )),
                      Divider(
                        color: Colors.grey,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (currentPage != "Profile") {
                              onTap ?? selectOntap(2, context);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: DrawerItems(
                            text: "Profile",
                            isOpen: currentPage == "Profile",
                          )),
                      Divider(
                        color: Colors.grey,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (currentPage != "ChangePassword") {
                              onTap ?? selectOntap(3, context);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: DrawerItems(
                            text: "Password",
                            isOpen: currentPage == "ChangePassword",
                          )),
                      Divider(
                        color: Colors.grey,
                      ),
                      GestureDetector(
                          onTap: () {
                            onTap ?? selectOntap(4, context);
                          },
                          child: DrawerItems(
                            text: "Logout",
                            isOpen: false,
                          )),
                      Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 0.015.sh,
                    width: width,
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                  ),
                  Expanded(
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: Container(
                        // height: height,
                        width: width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                                fit: FlexFit.loose,
                                child: container2 ?? SizedBox()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  selectOntap(int i, context) async {
    Connection connection = Connection();
    await connection.check();
    Navigator.of(context).pop();
    switch (i) {
      case 0:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      // shop: shop,
                      user: user!,
                    )),
            (route) => false);
        break;

      case 1:
        // if (shop.connection) {
        loader.showLoader("Fetching Leads", context);
        var body = await api.postData("leads/", {});
        if (body == "{}") {
          body = [];
        }
        if (kDebugMode) print(body);
        if (!body is String) {
          // if (body["leads"].length > 0) {

          for (int i = 0; i < body["leads"].length; i++) {
            Lead lead = Lead.fromJson(body["leads"][i]);
            if (lead.quoteSendAt == "") {
              newLeads.add(lead);
            } else {
              submittedLeads.add(lead);
            }
          }
          loader.hideLoader(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyLeads(
                        newLeads: newLeads,
                        submittedLeads: submittedLeads,
                        // shop: shop
                        user: user!,
                      )));
        } else {
          ShowToast.show("Something went wrong \n Try again after sometime");
        }
        // }
        // else{
        //   ShowToast.show("No Internet Connection", context);
        // }
        break;

      case 2:
        loader.showLoader("Fetching Profile", context);
        var body = await api.getData("profile/");
        await loader.hideLoader(context);
        User user = User.fromJson(body);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyProfile(
                  // shop: shop,
                  user: user!,
                )));
        break;

      case 3:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangePassword(
                  // shop: shop,
                  user: user!,
                )));
        break;

      case 4:
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
        break;
    }
  }
}
