
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  final Widget container1;
  final Widget container2;
  LoginWidget({this.container1, this.container2});
  double height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor:Colors.white ,
        resizeToAvoidBottomInset: false,
        body:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: height*0.2,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: container1,
              ),
            ),
            Expanded(
              child: Container(
                height: height,
                decoration: BoxDecoration(
                    color: Colors.white,
                ),
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                   color: Theme.of(context).primaryColor,
                    borderRadius:
                    BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal:0.06.sw ),
                    child: ListView
                      (
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,

                      children: [
                        container2,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
