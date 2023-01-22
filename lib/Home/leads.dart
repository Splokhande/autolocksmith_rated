import 'dart:async';

import 'package:autolocksmith/API/api.dart';
import 'package:autolocksmith/FCM/fcm.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:autolocksmith/model/lead_info.dart';
import 'package:autolocksmith/widgets/DashBoardWidget.dart';
import 'package:autolocksmith/widgets/loader.dart';
import 'package:autolocksmith/widgets/toast.dart';
import 'package:autolocksmith/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyLeads extends StatefulWidget {
  final List<Lead> newLeads;
  final List<Lead> submittedLeads;
  User user;
  final bool showNewLead;

  MyLeads({this.newLeads, this.submittedLeads, this.user, this.showNewLead});

  @override
  _MyLeadsState createState() => _MyLeadsState();
}

class _MyLeadsState extends State<MyLeads> {
  TextEditingController _search = TextEditingController();
  double height, width;
  bool selected = true;
  String title = "";
  String subtitle = "";
  API api = API();
  List<Lead> newLeads = [];
  List<Lead> submittedLeads = [];
  FCMConfig fcm = FCMConfig();

  @override
  void initState() {
    fcm.initialize(context);
    // TODO: implement initState
    super.initState();
    selected = widget.showNewLead ?? true;
    newLeads = widget.newLeads;
    submittedLeads = widget.submittedLeads;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LeadBoardWidget(
      currentPage: "Leads",
      header: "Leads",
      user: widget.user,
      widget: TextFormFieldWidget(
        controller: _search,
        hint: "Search",
        suffixIcon: Icon(
          Icons.search,
          size: 0.07.sw,
        ),
        onChanged: (String value) {
          if (value.length > 1) {
            submittedLeads = widget.submittedLeads;
            newLeads = widget.newLeads;

            List<Lead> lead1 = [];
            List<Lead> lead2 = [];

            for (int i = 0; i < newLeads.length; i++) {
              if ((newLeads[i].name.toLowerCase() +
                      newLeads[i].mapLocation.toLowerCase() +
                      newLeads[i].zipcode.toLowerCase() +
                      newLeads[i].email +
                      ("rl" + newLeads[i].quoteRequestId.toString()))
                  .replaceAll(" ", "")
                  .contains(value.toString().toLowerCase())) {
                if (!lead1.contains(newLeads[i])) {
                  lead1.add(newLeads[i]);
                }
              }
              // if (newLeads[i]
              //     .mapLocation
              //     .toLowerCase()
              //     .contains(value.toString().toLowerCase())) {
              //   if (!lead1.contains(newLeads[i])) {
              //     lead1.add(newLeads[i]);
              //   }
              // }
              // if (newLeads[i]
              //     .email
              //     .toLowerCase()
              //     .contains(value.toString().toLowerCase())) {
              //   if (!lead1.contains(newLeads[i])) {
              //     lead1.add(newLeads[i]);
              //   }
              // }
              // if (newLeads[i]
              //     .quoteRequestId
              //     .toString()
              //     .toLowerCase()
              //     .contains(value.toString().substring(2).toLowerCase())) {
              //   if (!lead1.contains(newLeads[i])) {
              //     lead1.add(newLeads[i]);
              //   }
              // }
            }
            for (int i = 0; i < submittedLeads.length; i++) {
              if ((submittedLeads[i].name.toLowerCase() +
                      submittedLeads[i].mapLocation.toLowerCase() +
                      submittedLeads[i].zipcode.toLowerCase() +
                      submittedLeads[i].email +
                      ("rl" + submittedLeads[i].quoteRequestId.toString()))
                  .replaceAll(" ", "")
                  .contains(value.toString().toLowerCase())) {
                if (!lead2.contains(submittedLeads[i])) {
                  lead2.add(submittedLeads[i]);
                }
              }
              //   if (submittedLeads[i]
              //       .quote
              //       .toLowerCase()
              //       .contains(value.toString().toLowerCase())) {
              //     if (!lead2.contains(submittedLeads[i])) {
              //       lead2.add(submittedLeads[i]);
              //     }
              //   }
              //   if (submittedLeads[i]
              //       .email
              //       .toLowerCase()
              //       .contains(value.toString().toLowerCase())) {
              //     if (!lead2.contains(submittedLeads[i])) {
              //       lead2.add(submittedLeads[i]);
              //     }
              //   }
              //   if (submittedLeads[i]
              //       .quoteRequestId
              //       .toString()
              //       .toLowerCase()
              //       .contains(value.toString().substring(2).toLowerCase())) {
              //     if (!lead2.contains(submittedLeads[i])) {
              //       lead2.add(submittedLeads[i]);
              //     }
              //   }
            }
            setState(() {
              newLeads = lead1;
              submittedLeads = lead2;
            });
          } else {
            setState(() {
              newLeads = widget.newLeads;
              submittedLeads = widget.submittedLeads;
            });
          }
        },
      ),
      container2: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = true;
                      });
                    },
                    child: GradientTabBarButton(
                      text: "New",
                      icon: Icons.file_download,
                      isActive: selected,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = false;
                      });
                    },
                    child: GradientTabBarButton(
                        text: "Submitted",
                        icon: Icons.download_done_sharp,
                        isActive: !selected),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            Expanded(
              child: Container(
                // height: 610.h,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    selected
                        ? newLeads.length > 0
                            ? ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (_, i) {
                                  return GestureDetector(
                                    onTap: () async {
                                      Loader loader = Loader();
                                      loader.showLoader(
                                          "Fetching Details", context);
                                      LeadInfo leads = LeadInfo();
                                      var body = await api
                                          .getData("leads/${newLeads[i].id}/");
                                      loader.hideLoader(context);

                                      leads = LeadInfo.fromJson(body);
                                      List<String> list =
                                          leads.quote.vehicleHelp
                                              // .replaceAll("\$*\$", "'")
                                              // .split("#");
                                              .split(",");
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LeadsDetails(
                                                    header:
                                                        "${newLeads[i].createdDate} | RL${newLeads[i].quoteRequestId}",
                                                    leads: leads,
                                                    help: list,
                                                    id: newLeads[i]
                                                        .quoteRequestId
                                                        .toString(),
                                                    // user: widget.shop,
                                                    user: widget.user,
                                                    newLeads: widget.newLeads,
                                                    submittedLeads:
                                                        widget.submittedLeads,
                                                    isSubmitted: false,
                                                  )));
                                    },
                                    child: LeadTextFieldWidget(
                                      title: newLeads[i].createdDate,
                                      name: newLeads[i].name,
                                      subtitle:
                                          newLeads[i].quoteRequestId.toString(),
                                      address: newLeads[i].mapLocation
                                      // +
                                      // ", " +
                                      // newLeads[i].zipcode
                                      ,
                                    ),
                                  );
                                },
                                separatorBuilder: (_, i) {
                                  return SizedBox(
                                    height: 20.h,
                                  );
                                },
                                itemCount: newLeads.length)
                            : WhiteTextWidget(
                                text: "No lead(s) found.",
                                fontSize: 15.sp,
                              )
                        : submittedLeads.length > 0
                            ? ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (_, i) {
                                  return GestureDetector(
                                    onTap: () async {
                                      Loader loader = Loader();
                                      loader.showLoader(
                                          "Fetching Details", context);
                                      LeadInfo leads = LeadInfo();
                                      debugPrint(
                                          'leads/${submittedLeads[i].id}');
                                      var body = await api.getData(
                                          "leads/${submittedLeads[i].id}/");
                                      loader.hideLoader(context);

                                      leads = LeadInfo.fromJson(body);
                                      List<String> list =
                                          leads.quote.vehicleHelp
                                              // .replaceAll("\$*\$", "'")
                                              // .split("#");
                                              .split(",");
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LeadsDetails(
                                                    header:
                                                        "${submittedLeads[i].createdDate} | RL${submittedLeads[i].quoteRequestId}",
                                                    leads: leads,
                                                    help: list,
                                                    id: submittedLeads[i]
                                                        .quoteRequestId
                                                        .toString(),
                                                    // user: widget.shop,
                                                    user: widget.user,
                                                    newLeads: widget.newLeads,
                                                    submittedLeads:
                                                        widget.submittedLeads,
                                                    isSubmitted: true,
                                                  )));
                                    },
                                    child: LeadTextFieldWidget(
                                      title: submittedLeads[i].createdDate,
                                      name: submittedLeads[i].name,
                                      subtitle: submittedLeads[i]
                                          .quoteRequestId
                                          .toString(),
                                      address: submittedLeads[i].mapLocation
                                      // ??
                                      // "" + ", " + submittedLeads[i].zipcode
                                      ,
                                    ),
                                  );
                                },
                                separatorBuilder: (_, i) {
                                  return SizedBox(
                                    height: 20.h,
                                  );
                                },
                                itemCount: submittedLeads.length)
                            : WhiteTextWidget(
                                text: "No lead(s) found.",
                                fontSize: 15.sp,
                              )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeadsDetails extends StatefulWidget {
  final String header;
  final String id;
  final LeadInfo leads;
  final List<Lead> newLeads;
  final List<Lead> submittedLeads;
  User user;
  final bool isSubmitted;
  final List<String> help;

  LeadsDetails(
      {this.header,
      this.leads,
      this.help,
      this.id,
      this.user,
      this.submittedLeads,
      this.newLeads,
      this.isSubmitted});

  @override
  _LeadsDetailsState createState() => _LeadsDetailsState();
}

class _LeadsDetailsState extends State<LeadsDetails> {
  TextEditingController _quote = TextEditingController();
  bool isEdit = false;
  FCMConfig fcm = FCMConfig();
  Future<void> _launched;
  @override
  void initState() {
    // TODO: implement initState
    isEdit = widget.isSubmitted;
    _quote.text = widget.leads.quote == null ? "" : widget.leads.lead.quote;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _quote.dispose();
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
    double titleSize = 0.00012.sw;
    return DashBoardWidget(
        header: "${widget.header}",
        // shop: widget.shop,
        user: widget.user,
        container2: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.025.sw),
          child: Container(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 18.h,
                ),
                ListTile(
                  title: Text(
                    "Lead",
                    // "Lead",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
                  ),
                  trailing: GestureDetector(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return DeleteCustomDialog(
                              onTap: () async {
                                Loader loader = Loader();
                                loader.showLoader("Deleting lead", context);
                                API api = API();
                                var body = await api
                                    .deleteData("leads/${widget.leads.lead.id}/"
                                        // "/?user_id=${widget.user.id}"
                                        );

                                loader.hideLoader(context);

                                if (!(body is String)) {
                                  if (widget.isSubmitted) {
                                    widget.submittedLeads.removeWhere(
                                        (element) =>
                                            element.quoteRequestId.toString() ==
                                            widget.id);
                                  } else {
                                    widget.newLeads.removeWhere((element) =>
                                        element.quoteRequestId.toString() ==
                                        widget.id);
                                  }

                                  // shop.fromSharedPreference();
                                  ShowToast.show("Lead deleted successfully");
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyLeads(
                                                // shop: widget.shop,
                                                user: widget.user,
                                                showNewLead: true,
                                                newLeads: widget.newLeads,
                                                submittedLeads:
                                                    widget.submittedLeads,
                                              )),
                                      (route) => false);
                                } else {
                                  ShowToast.show("Something went wrong");
                                } // Dismiss alert dialog
                              },
                              title: "Success",
                              description:
                                  "Are you sure you want to delete this lead?",
                              buttonText: "Okay",
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        "asset/dustbin.png",
                        width: 0.05.sw,
                      )),
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.035.sw),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.05.sw, vertical: 0.01.sh),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "I am in:",
                                textAlign: TextAlign.start,
                                maxLines: 5,
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontSize: 0.04.sw,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.leads.quote.mapLocation}",
                                maxLines: 5,
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                  fontSize: 0.04.sw,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ///
                      SizedBox(height: 0.01.sh),
                      WhiteRowTextWidget(
                        text: "Property:",
                        fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                        text2: widget.leads.quote.vehicleMotor,
                        fontSize2: 15.sp,
                      ),
                      // SizedBox(height: 0.01.sh),
                      // WhiteRowTextWidget(
                      //   text: "Vehicle",
                      //   fontWeight: FontWeight.bold,
                      //   fontSize: titleSize,
                      //   text2: widget.leads.quote.vehicleMotor,
                      //   fontSize2: 15.sp,
                      // ),
                      // SizedBox(height: 0.01.sh),
                      // WhiteRowTextWidget(
                      //   text: "Year",
                      //   fontWeight: FontWeight.bold,
                      //   fontSize: titleSize,
                      //   text2: widget.leads.quote.vehicleYear,
                      //   fontSize2: 15.sp,
                      // ),
                      // SizedBox(height: 0.01.sh),
                      // WhiteRowTextWidget(
                      //   text: "Make",
                      //   fontWeight: FontWeight.bold,
                      //   fontSize: titleSize,
                      //   text2: widget.leads.quote.vehicleMake,
                      //   fontSize2: 15.sp,
                      // ),
                      // SizedBox(height: 0.01.sh),
                      // WhiteRowTextWidget(
                      //   text: "Model",
                      //   fontWeight: FontWeight.bold,
                      //   fontSize: titleSize,
                      //   text2: widget.leads.quote.vehicleModel,
                      //   fontSize2: 15.sp,
                      // ),
                      // if (widget.leads.quote.vehicleVin != null)
                      //   SizedBox(height: 0.01.sh),
                      // if (widget.leads.quote.vehicleVin != null)
                      //   WhiteRowTextWidget(
                      //     text:
                      //         // widget.leads.quote.vehicleVin == "United States"
                      //         //     ?
                      //         "VIN"
                      //     // : "Reg"
                      //     ,
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: titleSize,
                      //     text2: widget.leads.quote.vehicleVin,
                      //     fontSize2: 15.sp,
                      //   ),
                      SizedBox(height: 0.01.sh),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 0.01.sh,
                            ),
                            WhiteRowTextWidget(
                              text: "Problem",
                              fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                              text2: "",
                              fontSize2: 0.035,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (_, i) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.05.sw,
                                          right: 0.05.sw,
                                          bottom: 10.h),
                                      child: Row(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.start,
                                        //     MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.arrow_forward_ios_sharp,
                                                  color: Colors.white,
                                                  size: 0.025.sw,
                                                ),
                                              )),
                                          SizedBox(
                                            width: 0.025.sw,
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.help[i],
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  fontSize: 15.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, i) {
                                    return SizedBox(
                                      height: 0.5.h,
                                    );
                                  },
                                  itemCount: widget.help.length),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 0.01.sh),
                      WhiteRowTextWidget(
                        text: "Needed:",
                        fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                        text2: widget.leads.quote.schedule ?? "Needed",
                        fontSize2: 0.035,
                      ),
                      SizedBox(
                        height: 0.015.sh,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.01.sw, vertical: 0.01.sh),
                          child: ListTile(
                            title: Text("Details:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 0.04.sw)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                widget.leads.quote.moreInfo
                                    .replaceAll("&#39;", "'"),
                                style: TextStyle(
                                    fontSize: 0.04.sw,
                                    color: Theme.of(context).canvasColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.015.sh,
                      ),
                      Visibility(
                        visible: !(widget.leads.quote.imageList.length == 0),
                        child: Column(
                          children: [
                            if (widget.leads.quote.imageList.length > 0)
                              WhiteRowTextWidget(
                                text: "Photo(s):",
                                fontWeight: FontWeight.bold,
                                fontSize: titleSize,
                                text2: "",
                                fontSize2: 0.035,
                              ),
                            if (widget.leads.quote.imageList.length > 0)
                              for (int i = 0;
                                  i < widget.leads.quote.imageList.length;
                                  i++)
                                ImageContainer(
                                  image: widget.leads.quote.imageList[i].url,
                                ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0.015.sh,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 0.05.sw, top: 0.015.sh, bottom: 0.015.sh),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 0.25.sw,
                                    child: Text(
                                      "Name:",
                                      style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    widget.leads.quote.name,
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.01.sh),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    _launched = _openUrl(
                                        'tel:${widget.leads.quote.telephoneNo}');
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 0.25.sw,
                                      child: Text(
                                        "Telephone:",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      widget.leads.quote.telephoneNo,
                                      style: TextStyle(
                                          color: Color(0xff0037a6),
                                          fontSize: 15.sp),
                                    )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 0.01.sh),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    _launched = _openUrl(
                                        'mailto:${widget.leads.quote.email}');
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 0.25.sw,
                                      child: Text(
                                        "Email:",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).canvasColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: Text(
                                        widget.leads.quote.email,
                                        style: TextStyle(
                                          color: Color(0xff0037a6),
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 0.01.sh),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.015.sh,
                      ),
                      Text("Submit your quote",
                          style: TextStyle(
                              color: Theme.of(context).canvasColor,
                              fontSize: 0.04.sw,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 0.015.sh,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 0.05.sw, top: 0.015.sh, bottom: 0.015.sh),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                ),
                                children: [
                                  // TextSpan(
                                  //     text: "Note: ",
                                  //     style: TextStyle(
                                  //         color: Theme.of(context).canvasColor,
                                  //         fontWeight: FontWeight.bold,
                                  //         fontSize: 0.04.sw)),
                                  TextSpan(
                                      text:
                                          "Other locksmiths in your area may be quoting for this job."
                                          " Be competitve with your pricing.",
                                      style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                          fontSize: 0.04.sw))
                                ]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.015.sh,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 0.05.sw, top: 0.015.sh, bottom: 0.015.sh),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Make everything clear for the customer:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 0.01.sh),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0, right: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.blue.shade400,
                                            minRadius: 0.018.sw,
                                            child: Icon(
                                              Icons.arrow_forward_ios_sharp,
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                              size: 15.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 0.05.sw,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Provide full details of the work including price.",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                fontSize: 0.035.sw),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.01.sh),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.blue.shade400,
                                            minRadius: 0.018.sw,
                                            child: Icon(
                                              Icons.arrow_forward_ios_sharp,
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                              size: 15.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 0.05.sw,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Provide available dates as to when you can carry out the work.",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                fontSize: 0.035.sw),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.01.sh),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.blue.shade400,
                                            minRadius: 0.018.sw,
                                            child: Icon(
                                              Icons.arrow_forward_ios_sharp,
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                              size: 15.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 0.05.sw,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Any other information you feel will help the customer book you.",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                fontSize: 0.035.sw),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.01.sh),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.blue.shade400,
                                            minRadius: 0.018.sw,
                                            child: Icon(
                                              Icons.arrow_forward_ios_sharp,
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                              size: 15.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 0.05.sw,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "No need to include your contact details in the box below.",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                fontSize: 0.035.sw),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.015.sh,
                      ),
                      // Text("Quote the customer using the box below:",
                      //     style: TextStyle(
                      //         color: Theme.of(context).canvasColor,
                      //         fontSize: 0.04.sw,
                      //         fontWeight: FontWeight.bold)),
                      // SizedBox(
                      //   height: 0.015.sh,
                      // ),
                      TextFormFieldWidget(
                        label: "",
                        controller: _quote,
                        isEnabled: !isEdit,
                        hint: "",
                        maxLines: 5,
                        type: TextInputType.multiline,
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          if (isEdit) {
                            setState(() {
                              isEdit = false;
                            });
                          } else {
                            if (_quote.text == "") {
                              ShowToast.show(
                                  "Please provide your quote details");
                            } else {
                              if (_quote.text == widget.leads.lead.quote) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyLeads(
                                              // shop: widget.shop,
                                              user: widget.user,
                                              newLeads: widget.newLeads,
                                              submittedLeads:
                                                  widget.submittedLeads,
                                              showNewLead: false,
                                            )),
                                    (route) => false);
                              } else {
                                Loader loader = Loader();
                                loader.showLoader("Please wait", context);
                                API api = API();
                                String quote = _quote.text;
                                quote = quote.replaceAll("£", "psas");
                                debugPrint(
                                    '{"lead_id": ${widget.leads.lead.id}, "quote": $quote}');
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                var body = await api.putData(
                                    "submit-quote/${widget.leads.quote.id}/", {
                                  "lead_id": widget.leads.lead.id,
                                  "quote": quote
                                });

                                if (kDebugMode) print(body);

                                loader.hideLoader(context);
                                if (!(body is String)) {
                                  FlutterAppBadger.updateBadgeCount(
                                      widget.newLeads.length - 1);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        if (!widget.isSubmitted) {
                                          Lead lead = Lead();
                                          if (kDebugMode)
                                            print(widget.newLeads.length);
                                          for (int i = 0;
                                              i < widget.newLeads.length;
                                              i++) {
                                            if (widget
                                                    .newLeads[i].quoteRequestId
                                                    .toString() ==
                                                widget.id) {
                                              lead = widget.newLeads[i];
                                            }
                                          }
                                          widget.submittedLeads.insert(0, lead);
                                          widget.newLeads.removeWhere(
                                              (element) =>
                                                  element.quoteRequestId
                                                      .toString() ==
                                                  widget.id);
                                        }
                                        var duration = new Duration(seconds: 2);
                                        Timer(duration, () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyLeads(
                                                        // shop: widget.shop,
                                                        user: widget.user,
                                                        newLeads:
                                                            widget.newLeads,
                                                        submittedLeads: widget
                                                            .submittedLeads,
                                                        showNewLead: false,
                                                      )),
                                              (route) => false);
                                        });
                                        return WillPopScope(
                                          onWillPop: () async {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyLeads(
                                                          // shop: widget.shop,
                                                          user: widget.user,
                                                          newLeads:
                                                              widget.newLeads,
                                                          submittedLeads: widget
                                                              .submittedLeads,
                                                          showNewLead: false,
                                                        )),
                                                (route) => false);
                                            return Future.value(true);
                                          },
                                          child: SucessCustomDialog(
                                            title: "Success",
                                            description:
                                                "Quote Submitted Successfully",
                                            buttonText: "Okay",
                                          ),
                                        );
                                      });
                                }
                              }
                            }
                          }
                        },
                        child: isEdit
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffbbdefa),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(0.03.sw),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // +
                                        RichText(
                                          text: TextSpan(
                                              text:
                                                  "Your quote has been submitted to the customer.",
                                              style: TextStyle(
                                                  color: Colors.black),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        " You can edit and re-submit a new quote if need be.",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black))
                                              ]),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Container(
                                            width: 0.4.sw,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.pink,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(0.03.sw),
                                              child: Center(
                                                child: Text(
                                                  "EDIT QUOTE",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 0.035.sw),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ))
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(0.03.sw),
                                  child: Center(
                                    child: Text(
                                      "SUBMIT MY QUOTE",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 0.035.sw),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 0.2.sh,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
