import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginWidget extends StatelessWidget {
  final Widget container1;
  final Widget container2;

  LoginWidget({required this.container1, required this.container2});

  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          shrinkWrap: true,

          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          children: [
            Center(
              child: Container(
                height: height * 0.2,
                width: width,
                decoration: BoxDecoration(color: Colors.white),
                child: container1,
              ),
            ),
            Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
                  child: ListView(
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
          ],
        ),
      ),
    );
  }
}
