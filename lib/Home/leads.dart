

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:autolocksmith/API/api.dart';
import 'package:autolocksmith/FCM/fcm.dart';
import 'package:autolocksmith/model/User.dart';
import 'package:autolocksmith/model/leads.dart';
import 'package:autolocksmith/widgets/DashBoardWidget.dart';
import 'package:autolocksmith/widgets/loader.dart';
import 'package:autolocksmith/widgets/toast.dart';
import 'package:autolocksmith/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyLeads extends StatefulWidget {
  final List<Lead> newLeads;
  final List<Lead> submittedLeads;
  final Shop shop;
  final bool showNewLead;
  MyLeads({this.newLeads, this.submittedLeads, this.shop, this.showNewLead});
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
  Loader loader = Loader();
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
      shop: widget.shop,
      widget:  TextFormFieldWidget(
        controller: _search,
        hint: "Search",
        suffixIcon: Icon(Icons.search,size: 0.07.sw,),
        onChanged: (value){
          if(value.length>1){
            submittedLeads = widget.submittedLeads;
            newLeads = widget.newLeads;
            List<Lead> lead1 = [];
            List<Lead> lead2 = [];
            for(int i=0;i<newLeads.length;i++){
              if(newLeads[i].uniquecode.toLowerCase().contains(value.toString().toLowerCase())){
                if(!lead1.contains(newLeads[i])) {
                  lead1.add(newLeads[i]);
                }
              }
               if(newLeads[i].added_date.toLowerCase().contains(value.toString().toLowerCase())){
                 if(!lead1.contains(newLeads[i])) {
                      lead1.add(newLeads[i]);
                    }
                  }
               if(newLeads[i].address.toLowerCase().contains(value.toString().toLowerCase())){
                 if(!lead1.contains(newLeads[i])) {
                      lead1.add(newLeads[i]);
                    }
                  }
               if(newLeads[i].username.toLowerCase().contains(value.toString().toLowerCase())){
             if(!lead1.contains(newLeads[i])) {
                  lead1.add(newLeads[i]);
                }
              }
            }
            for(int i=0;i<submittedLeads.length;i++){
              if(submittedLeads[i].uniquecode.toLowerCase().contains(value.toString().toLowerCase())){
                  if(!lead2.contains(submittedLeads[i])) {
                    lead2.add(submittedLeads[i]);
                  }
                }
             if(submittedLeads[i].added_date.toLowerCase().contains(value.toString().toLowerCase())){
                if(!lead2.contains(submittedLeads[i])) {
                  lead2.add(submittedLeads[i]);
                }
              }
             if(submittedLeads[i].address.toLowerCase().contains(value.toString().toLowerCase())){
               if(!lead2.contains(submittedLeads[i])) {
                  lead2.add(submittedLeads[i]);
                }
              }
             if(submittedLeads[i].username.toLowerCase().contains(value.toString().toLowerCase())){
               if(!lead2.contains(submittedLeads[i])) {
                  lead2.add(submittedLeads[i]);
                }
              }
            }
            setState(() {
              newLeads = lead1;
              submittedLeads = lead2;
            });
          }
          else{
            setState(() {
              newLeads = widget.newLeads;
              submittedLeads = widget.submittedLeads;
            });
          }


        },
      ),
      container2: Container(
        padding: EdgeInsets.symmetric(horizontal: width*0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: height *0.05,),
            Container(
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
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
                    onTap: (){
                      setState(() {
                        selected = false;
                      });
                    },
                    child: GradientTabBarButton(
                      text: "Submitted",
                      icon: Icons.download_done_sharp,
                      isActive: !selected
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.02.sh,),
            Expanded(
              child: Container(
                // height: 610.h,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    selected ?
                    newLeads.length>0 ?ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (_,i){
                          return  GestureDetector(
                            onTap: ()async{
                              Loader loader = Loader();
                              loader.showLoader(
                                  "Fetching Details", context);
                              LeadsDetail leads = LeadsDetail();
                              var res = await api
                                  .postData("getsinglerecord.php?acquid=${newLeads[i].acquid}");
                              loader.hideLoader(context);
                              var body = jsonDecode(res.body);
                              leads = LeadsDetail.fromMap(body);
                              List<String> list = leads.damageWindow.replaceAll("\$*\$", "'").split("#");
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>
                                      LeadsDetails(
                                        header: "${newLeads[i].added_date} | ${newLeads[i].uniquecode}",
                                        leads: leads,help: list,
                                        acquid: newLeads[i].acquid,
                                        shop: widget.shop,
                                        newLeads: widget.newLeads,
                                        submittedLeads: widget.submittedLeads,
                                        isSubmitted: false,
                                      )));
                            },
                            child: LeadTextFieldWidget(
                              title: newLeads[i].added_date,
                              name: newLeads[i].username,
                              subtitle: newLeads[i].uniquecode,
                              address: newLeads[i].address,
                            ),
                          );
                        }, separatorBuilder: (_, i) {
                      return SizedBox(height: 20.h,);
                    }, itemCount: newLeads.length)
                        : WhiteTextWidget(
                      text: "No lead(s) found.",
                      fontSize: 15.sp,
                    ):
                    submittedLeads.length>0 ? ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (_,i){
                          return  GestureDetector(
                            onTap: ()async{
                              Loader loader = Loader();
                            loader.showLoader(
                                "Fetching Details", context);
                            LeadsDetail leads = LeadsDetail();
                              var res = await api
                                  .postData("getsinglerecord.php?acquid=${submittedLeads[i].acquid}");
                              print(res.body);
                              loader.hideLoader(context);
                              var body = jsonDecode(res.body);
                              leads = LeadsDetail.fromMap(body);
                              List<String> list = leads.damageWindow.replaceAll("\$*\$", "'").split("#");
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>
                                      LeadsDetails(
                                        header: "${submittedLeads[i].added_date} | ${submittedLeads[i].uniquecode}",
                                        leads: leads,
                                        help: list,
                                        acquid: submittedLeads[i].acquid,
                                        shop: widget.shop,
                                        newLeads: widget.newLeads,
                                        submittedLeads: widget.submittedLeads,
                                        isSubmitted: true,
                                      )));
                            },
                            child: LeadTextFieldWidget(
                              title: submittedLeads[i].added_date,
                              name: submittedLeads[i].username,
                              subtitle: submittedLeads[i].uniquecode,
                              address: submittedLeads[i].address,

                            ),
                          );
                        }, separatorBuilder: (_, i) {
                      return SizedBox(height:20.h,);
                    }, itemCount: submittedLeads.length) :
                        WhiteTextWidget(
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
 final String acquid;
 final LeadsDetail leads;
 final List<Lead> newLeads;
 final List<Lead> submittedLeads;
 final Shop shop;
 final bool isSubmitted;
 final List<String> help;
  LeadsDetails({this.header, this.leads, this.help, this.acquid, this.shop, this.submittedLeads, this.newLeads, this.isSubmitted});
  @override
  _LeadsDetailsState createState() => _LeadsDetailsState();
}

class _LeadsDetailsState extends State<LeadsDetails> {
  TextEditingController _quote = TextEditingController();
  bool isEdit = false;
  FCMConfig fcm = FCMConfig();
  @override
  void initState() {
    fcm.initialize(context);
    // TODO: implement initState
    isEdit = widget.isSubmitted;
    _quote.text = widget.leads.quoteDetails == null?"":widget.leads.quoteDetails.replaceAll("psas", "£");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _quote.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double titleSize =  0.00012.sw;
    return DashBoardWidget(

      header: widget.header,
        shop: widget.shop,
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
                title: Text("Lead",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.sp),),
                trailing: GestureDetector(
                    onTap: (){
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return DeleteCustomDialog(
                              onTap: ()async{
                                      Loader loader = Loader();
                                      loader.showLoader("Deleting lead", context);
                                        API api = API();
                                        var res  = await api.postData("deletelead.php?acquid=${widget.acquid}&shop_id=${widget.shop.id}&deletelead=1");
                                        var body = jsonDecode(res.body);
                                        loader.hideLoader(context);

                                        if(body["status"] == "success") {
                                          if(widget.isSubmitted){
                                            widget.submittedLeads.removeWhere((element) => element.acquid == widget.acquid);
                                          }else{
                                            widget.newLeads.removeWhere((element) => element.acquid == widget.acquid);
                                          }
                                          Shop shop = Shop();
                                          shop.fromSharedPreference();
                                          ShowToast.show("Lead deleted successfully", context);
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => MyLeads(shop: shop,showNewLead: true,newLeads: widget.newLeads,submittedLeads: widget.submittedLeads,)),(route) => false);
                                        }
                                        else{
                                          // Toast.show("Something went wrong", context);
                                        } // Dismiss alert dialog

                              },
                              title: "Success",
                              description: "Are you sure you want to delete this lead?",
                              buttonText: "Okay",
                            );
                          },
                        );
                      },
                    child:Image.asset("asset/dustbin.png",width: 0.05.sw,)),
                    ),
              SizedBox(
                height: 0.01.sh,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.035.sw),
                child:  ListView(
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
                        padding: EdgeInsets.symmetric(horizontal: 0.05.sw,vertical:  0.01.sh),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "I am in:",
                              textAlign: TextAlign.start,
                              maxLines: 5,
                              style: TextStyle(color: Theme.of(context).canvasColor,
                                  fontSize: 0.04.sw,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "${widget.leads.vehicleLocation}",
                              maxLines: 5,
                              style: TextStyle(color: Theme.of(context).canvasColor,
                                  fontSize: 0.04.sw,
                              ),
                            ),
                          ],

                        ),
                      ),
                    ),
                    SizedBox(height: 0.01.sh),
                    WhiteRowTextWidget(
                      text: "Vehicle",fontWeight: FontWeight.bold,
                      fontSize:titleSize,
                      text2: widget.leads.vehicleType,fontSize2:15.sp,
                    ),
                    SizedBox(height: 0.01.sh),
                    WhiteRowTextWidget(
                      text: "Year",fontWeight: FontWeight.bold, fontSize: titleSize,
                      text2: widget.leads.yearVehicle,fontSize2: 15.sp,
                    ),
                    SizedBox(height: 0.01.sh),
                    WhiteRowTextWidget(
                      text: widget.shop.country == "United States"?"VIN":"Reg",fontWeight: FontWeight.bold, fontSize:titleSize,
                      text2:  widget.leads.vehicleReg,fontSize2: 15.sp,
                    ),
                    SizedBox(height: 0.01.sh),
                    WhiteRowTextWidget(
                      text: "Make",fontWeight: FontWeight.bold, fontSize:titleSize,
                      text2: widget.leads.makeOfVehicle,fontSize2: 15.sp,
                    ),
                    SizedBox(height: 0.01.sh),
                    WhiteRowTextWidget(
                      text: "Model",fontWeight: FontWeight.bold, fontSize:titleSize,
                      text2: widget.leads.modelVehicle,fontSize2: 15.sp,
                    ),
                    SizedBox(height: 0.01.sh),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [

                          SizedBox(height: 0.01.sh,),
                          WhiteRowTextWidget(
                            text: "Help",fontWeight: FontWeight.bold, fontSize:titleSize,
                            text2: "",fontSize2: 0.035,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom:8.0),
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (_,i){
                              return Padding(
                                padding: EdgeInsets.only(left: 0.05.sw, right: 0.05.sw, bottom: 10.h),
                                child: Row(
                                  children: [
                                    Icon(Icons.watch_later,color: Colors.lightBlueAccent,size: 0.045.sw,),
                                    SizedBox(width: 0.025.sw,),
                                    Text(widget.help[i],style: TextStyle(color: Theme.of(context).canvasColor,
                                        fontSize: 15.sp),),
                                  ],
                                ),
                              );
                            }, separatorBuilder: (_,i){
                              return  SizedBox(height: 0.5.h,);
                            }, itemCount: widget.help.length),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 0.01.sh),
                    WhiteRowTextWidget(
                      text: "Needed:",fontWeight: FontWeight.bold, fontSize:titleSize,
                      text2: widget.leads.needed,fontSize2: 0.035,
                    ),
                    SizedBox(height: 0.015.sh,),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(5),
                    //   ),
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 0.01.sw,vertical:  0.01.sh),
                    //     child: ListTile(
                    //       title: Text("Billings:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 0.04.sw)
                    //       ),
                    //       subtitle:Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(widget.leads.whoPay,
                    //             style: TextStyle(fontSize: 0.04.sw, color: Theme.of(context).canvasColor),),
                    //           if(widget.leads.insuranceName != "" && widget.leads.insuranceName != null)
                    //             Text(widget.leads.insuranceName,
                    //               style: TextStyle(fontSize: 0.04.sw, color: Theme.of(context).canvasColor),),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 0.015.sh,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.01.sw,vertical:  0.01.sh),
                        child: ListTile(

                          title: Text("Details:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 0.04.sw)),
                          subtitle:Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Text(widget.leads.additionInfo.replaceAll("&#39;", "'"),
                              style: TextStyle(fontSize: 0.04.sw, color: Theme.of(context).canvasColor),),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.015.sh,),

                      Visibility(
                        visible: !( widget.leads.carDamagePhoto == "https://www.autolocksmiths.com/quoteimages/"),
                        child: Column(
                          children: [
                            WhiteRowTextWidget(
                            text: "Images:",fontWeight: FontWeight.bold, fontSize: titleSize,
                            text2: "",fontSize2: 0.035,
                            ),
                            SizedBox(height: 0.015.sh,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.leads.carDamagePhoto,
                                width: 1.sw,
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width:  1.sw,
                                      height: 250.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 0.015.sh,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.05.sw,top: 0.015.sh,bottom: 0.015.sh),
                        child:  Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:0.25.sw,
                                  child: Text("Customer:",style: TextStyle(color: Theme.of(context).canvasColor,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),),
                                ),

                                Text(widget.leads.customerName,style: TextStyle(color: Theme.of(context).canvasColor,fontSize: 15.sp),),
                              ],
                            ),
                            SizedBox(height: 0.01.sh),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:0.25.sw,
                                  child: Text("Telephone:",style: TextStyle(color: Theme.of(context).canvasColor,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),),
                                ),

                                Expanded(child: Text(widget.leads.phone,style: TextStyle(color: Theme.of(context).canvasColor,fontSize: 15.sp),)),
                              ],
                            ),
                            SizedBox(height: 0.01.sh),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:0.25.sw,
                                  child: Text("Email:",style: TextStyle(color: Theme.of(context).canvasColor,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),),
                                ),

                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(right:16.0),
                                  child: Text(widget.leads.email,
                                    style: TextStyle(color: Theme.of(context).canvasColor,fontSize: 15.sp,),),
                                )),
                              ],
                            ),
                            SizedBox(height: 0.01.sh),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 0.015.sh,),
                    Text("Submit Quote",
                        style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: 0.04.sw,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.015.sh,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.05.sw,top: 0.015.sh,bottom: 0.015.sh),
                        child: RichText(
                          text:TextSpan(
                            style: TextStyle(color: Theme.of(context).canvasColor,),

                            children: [
                              TextSpan(text: "Note: ",
                              style: TextStyle(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold, fontSize:  0.04.sw)
                              ),
                              TextSpan(text: "Other auto locksmiths in your area are quoting for this job."
                                  " Be competitve with your pricing.",
                              style: TextStyle(color: Theme.of(context).canvasColor, fontSize:  0.04.sw)
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.015.sh,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(

                        padding: EdgeInsets.only(left: 0.05.sw,top: 0.015.sh,bottom: 0.015.sh),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Make everything clear to customer:",
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 0.01.sh),
                            Padding(
                              padding: const EdgeInsets.only(top:8.0, bottom:8.0, right: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(top:4.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blue.shade400,
                                          minRadius: 0.018.sw,
                                          child:   Icon(Icons.arrow_forward_ios_sharp,
                                            color: Theme.of(context).backgroundColor,
                                            size: 15.sp,),
                                        ),
                                      ),
                                      SizedBox(width: 0.05.sw
                                        ,),
                                      Expanded(
                                        child: Text("Provide full details of the work, including price.",
                                          style: TextStyle(color: Theme.of(context).canvasColor,
                                              fontSize: 0.035.sw),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.01.sh),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top:4.0),
                                        child:  CircleAvatar(
                                          backgroundColor: Colors.blue.shade400,
                                          minRadius: 0.018.sw,
                                          child:   Icon(Icons.arrow_forward_ios_sharp,
                                            color: Theme.of(context).backgroundColor,
                                            size: 15.sp,),
                                        ),
                                      ),
                                      SizedBox(width: 0.05.sw
                                        ,),
                                      Expanded(
                                        child: Text("Provide available dates as to when you carry out the work",
                                          style: TextStyle(color: Theme.of(context).canvasColor,
                                              fontSize: 0.035.sw),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.01.sh),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(top:4.0),
                                        child:  CircleAvatar(
                                          backgroundColor: Colors.blue.shade400,
                                          minRadius: 0.018.sw,
                                          child:   Icon(Icons.arrow_forward_ios_sharp,
                                            color: Theme.of(context).backgroundColor,
                                            size: 15.sp,),
                                        ),
                                      ),
                                      SizedBox(width: 0.05.sw
                                        ,),
                                      Expanded(
                                        child: Text("Any other information you will feel will help the customer book you",
                                          style: TextStyle(color: Theme.of(context).canvasColor,
                                              fontSize: 0.035.sw),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.01.sh),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(top:4.0),
                                        child:  CircleAvatar(
                                          backgroundColor: Colors.blue.shade400,
                                          minRadius: 0.018.sw,
                                          child:   Icon(Icons.arrow_forward_ios_sharp,
                                            color: Theme.of(context).backgroundColor,
                                            size: 15.sp,),
                                        ),
                                      ),
                                      SizedBox(width: 0.05.sw
                                        ,),
                                      Expanded(
                                        child: Text("No need to include your contact details in the box below",
                                          style: TextStyle(color: Theme.of(context).canvasColor,
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
                    SizedBox(height: 0.015.sh,),
                    Text("Quote the customer using the box below:",
                        style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: 0.04.sw,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.015.sh,),
                    TextFormFieldWidget(
                      label: "",
                      controller: _quote,
                      isEnabled: !isEdit,
                      hint: "",
                      maxLines: 5,
                      type: TextInputType.multiline,
                    ),
                    SizedBox(height: 0.02.sh,),
                    GestureDetector(
                      onTap:()async{
                        FocusScope.of(context).unfocus();
                        if(isEdit){
                          setState(() {
                            isEdit = false;
                          });
                        }else{
                          if(_quote.text == ""){
                            ShowToast.show("Please provide your quote details", context);
                          }else {
                            if (_quote.text == widget.leads.quoteDetails) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyLeads(
                                              shop: widget.shop,
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
                                quote= quote.replaceAll("£", "psas");

                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                var res = await api.postData(
                                    "postlead.php?shop_id=${sp.getString("id")}&acquid=${widget.acquid}&action=submitquote&quote_details=$quote");
                                var body = jsonDecode(res.body);
                                print(body["success"]);
                                print(body["status"]);
                               loader.hideLoader(context);
                                if (body["status"] == "success") {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        if(!widget.isSubmitted) {
                                          Lead lead = Lead();
                                          print(widget.newLeads.length);
                                          for (int i = 0;
                                              i < widget.newLeads.length;
                                              i++) {
                                            if (widget.newLeads[i].acquid ==
                                                widget.acquid) {
                                              lead = widget.newLeads[i];
                                            }
                                          }
                                          widget.submittedLeads.add(lead);
                                          widget.newLeads.removeWhere(
                                              (element) =>
                                                  element.acquid ==
                                                  widget.acquid);
                                        }
                                        var duration = new Duration(seconds: 2);
                                        Timer(duration, () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyLeads(
                                                        shop: widget.shop,
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
                                                          shop: widget.shop,
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
                      child:
                      isEdit?
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffbbdefa),
                          ),
                          child:Padding(
                            padding: EdgeInsets.all(0.03.sw),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Your quote has been submitted to the customer...",style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                   ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                ),
                                    Text("You can edit and re-submit a new quote if need be.",style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.5.sp
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                      width: 0.4.sw,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.pink,
                                      ),
                                      child:Padding(
                                        padding: EdgeInsets.all(0.03.sw),
                                        child: Center(
                                          child: Text("EDIT QUOTE",style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 0.035.sw
                                          ),),
                                        ),
                                      ) ),
                                ],
                              ),
                            ),
                          ) ):
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                            color: Color(0xff81b701),
                          ),
                          child:Padding(
                            padding: EdgeInsets.all(0.03.sw),
                            child: Center(
                              child: Text("SUBMIT MY QUOTE",style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                fontSize: 0.035.sw
                              ),),
                            ),
                          ),
                      ),
                    ),
                    SizedBox(height: 0.2.sh,),

                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
