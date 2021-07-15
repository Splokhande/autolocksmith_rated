import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class RichWidget extends StatelessWidget {
  String text1;
  String text2;
  String text3;
  RichWidget({this.text1,this.text2, this.text3});
  @override
  Widget build(BuildContext context) {
    return new RichText(
      text: new TextSpan(
        text: '$text1',
        style: TextStyle(color: Theme.of(context).canvasColor),
        children: <TextSpan>[
          new TextSpan(
              text: '$text2',
              style: new TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)),
          new TextSpan(text: ' $text3'),
        ],
      ),
    );
  }
}
class WhiteHeadTextWidget extends StatelessWidget {
  String text;
  double fontSize;
  double height, width;
  FontWeight fontWeight;
  WhiteHeadTextWidget({this.text,this.fontWeight, this.fontSize});
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text(text,
        maxLines: 2,
        style:TextStyle(color: Theme.of(context).backgroundColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
        ),
      ),
    );
  }
}
class WhiteTextWidget extends StatelessWidget {
  String text;
  double fontSize;
  double height, width;
  FontWeight fontWeight;
  WhiteTextWidget({this.text,this.fontWeight, this.fontSize});
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.08,vertical: height* 0.01),
        child: Center(
          child: Text(
            text,
            maxLines: 5,
            style: TextStyle(color: Theme.of(context).canvasColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}

///Leads
class WhiteRowTextWidget extends StatelessWidget {
  String text;
  String text2;
  double fontSize;
  double fontSize2;
  double height, width;
  FontWeight fontWeight;
  FontWeight fontWeight2;
  WhiteRowTextWidget({this.text,this.text2, this.fontWeight,this.fontWeight2, this.fontSize, this.fontSize2});
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),      
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05,vertical: height* 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(
              width: 0.25.sw,
              child: Text(
                "$text:",
                textAlign: TextAlign.start,
                maxLines: 5,
                style: TextStyle(color: Theme.of(context).canvasColor,
                        fontSize: 0.04.sw,
                        fontWeight: fontWeight
                ),
              ),
            ),
            Expanded(
              child: Text(
                text2,
                maxLines: 5,
                style: TextStyle(color: Theme.of(context).canvasColor,
                    fontSize: 0.04.sw,
                    fontWeight: fontWeight2
                ),
              ),
            ),
          ],

        ),
      ),
    );
  }
}
class TextFormFieldWidget extends StatelessWidget {
  TextEditingController controller;
  String hint;
  String label;
  TextInputType type;
  bool isPassword;
  Icon suffixIcon;
  int maxLines;
  Key key;
  Widget suffix;
  Function validate;
  Function onChanged;
  bool obscure;
  bool isEnabled;
  TextFormFieldWidget({this.label,this.maxLines, this.validate,
    this.controller, this.hint, this.type, this.suffixIcon,
    this.isPassword, this.isEnabled, this.onChanged,this.key});

  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return TextFormField(
      keyboardType: type,
      key: key,
      style: TextStyle(fontSize: 18.sp),
      textAlignVertical: TextAlignVertical.center,
      enabled: isEnabled ?? true,
      maxLines: maxLines ??null,
      controller: controller,
      textAlign: TextAlign.left,
      onChanged: onChanged,
      textInputAction: TextInputAction.newline,

      decoration: InputDecoration(

          contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          filled: true,
          fillColor: Colors.white,
          focusColor:Colors.white ,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none
            ),
          suffixIcon: suffixIcon,
          hintText: hint,
        hintStyle: TextStyle(fontSize: 18.sp),
        errorStyle: TextStyle(fontSize: 18.sp)
      ),
          validator: validate,

          obscureText: isPassword ?? false,
    );
  }
}
class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 55.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: gradient
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
            child: Center(child: child),
        ),
      ),
    );
  }
}
class GradientTabBarButton extends StatelessWidget {
  final bool isActive;
  IconData icon;
  String text;
  GradientTabBarButton({this.isActive, this.icon, this.text});

  @override
  Widget build(BuildContext context) {

    TextStyle isTextActive = TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w800, color: Colors.white);
    TextStyle isTextInactive = TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w800, color: Colors.grey);
    BoxDecoration isDecorationActive =BoxDecoration(
       gradient: LinearGradient(
           transform: GradientRotation(pi/2),
           colors: [Colors.indigo,Colors.lightBlueAccent]),
       borderRadius: BorderRadius.circular(10),
     );
    BoxDecoration isDecorationInactive = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15));
    Color activeIcon = Colors.white;
    Color inActiveIcon = Colors.grey;

    return Container(
      decoration:isActive ? isDecorationActive : isDecorationInactive,
      width: 0.42.sw,
      height: 0.06.sh,
      child: Padding(
        padding: EdgeInsets.all(0.008.sw),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color: isActive?activeIcon:inActiveIcon,size: 0.055.sw,),
            SizedBox(width: 0.02.sw),
            Text(text,style:isActive ? isTextActive : isTextInactive,)
          ],
        ),
      ),
    );
  }
}
class DrawerItems extends StatelessWidget {

  String text ="";
  bool isOpen = false;
  DrawerItems({this.text, this.isOpen});
  @override
  Widget build(BuildContext context) {


    return Container(
      width: 1.sw,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.045.sw, vertical: 0.005.sh),
          child: Text(
            text,
            style: isOpen?TextStyle(color: Color(0xffe30613),fontSize: 18.sp):TextStyle(fontSize: 18.sp),),
        )
    );
  }
}


class ProfileTextFieldWidget extends StatelessWidget {
  String title;
  String subtitle;

  ProfileTextFieldWidget({this.title, this.subtitle});
  double height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical:MediaQuery.of(context).size.height *0.01,
            horizontal:MediaQuery.of(context).size.width *0.025
        ),
        child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
              style: TextStyle(fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor, fontSize: 15.sp),),
           SizedBox(height:height*0.01),
            Text(subtitle,
              style: TextStyle(color: Theme.of(context).canvasColor, fontSize: 15.sp),),

          ],
        ),
      ),
    );
  }
}
class LeadTextFieldWidget extends StatelessWidget {
  String title;
  String subtitle;
  String name;
  String address;

  LeadTextFieldWidget({this.title, this.subtitle,this.address, this.name});

  @override
  Widget build(BuildContext context) {

    return Container(
      // height: 0.09.sh,
      padding : EdgeInsets.symmetric(vertical: 5),
      decoration : BoxDecoration(
        color : Colors.white,
        borderRadius : BorderRadius.all(Radius.circular(10)),
      ),
      child :
      Padding(
        padding: EdgeInsets.only(left: 0.02.sw, right: 0.03.sw, top:5.h,bottom: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(width: 0.015.sw),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 0.25.sw,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10.h,),
                        Text(title, style: TextStyle(fontSize: 15.sp),),
                        SizedBox(height: 5,),
                        Text(subtitle, style: TextStyle(fontSize: 15.sp))
                      ],
                    ),
                  ),
                  SizedBox(width: 0.001.sw,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10.h,),
                        Flexible(
                            fit: FlexFit.loose,
                            child: Text(name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp),)),
                        SizedBox(height: 5,),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(address?? "Address", style: TextStyle(fontSize: 15.sp)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 0.06.sw,),
                ],
              ),
            ),


            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible
                  (
                    fit: FlexFit.loose,
                    child: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey, size: 25.sp,)
                ),

              ],
            )
          ],
        ),
      )
    );
  }
}




class SucessCustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  SucessCustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });
  double padding = 5.h;
  double avatarRadius = 250.h;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[

        Container(
          padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
          margin: EdgeInsets.symmetric(vertical: avatarRadius,horizontal: 0.2.h),
          height: 200.h,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              SizedBox(height: 26.0),
              Image.asset("asset/done.png",height: 50.h,),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 0.05.sw,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}

class DeleteCustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;
  final Function onTap;

  DeleteCustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
    this.onTap
  });
  double padding = 5.h;
  double avatarRadius = 250.h;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[

        Container(
          padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
          margin: EdgeInsets.symmetric(vertical: avatarRadius,horizontal: 0.2.h),
          height: 2.sh,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              SizedBox(height: 26.0),
              Image.asset("asset/delete.png",height: 50.h,),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 0.05.sw,
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded
                    (
                    child: GestureDetector(
                      child: Center(
                      child: RaisedGradientButton(
                        onPressed: onTap,
                        gradient: LinearGradient(colors: [Colors.white,Colors.black,],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(0.65, 0.0),
                          transform:  GradientRotation(pi /2),
                        ), child: Center(
                        child: WhiteHeadTextWidget(
                          text: "Ok",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,)
                        ,)
                        ,
                      )
                      ,),
                    ),
                  ),
                  SizedBox(
                    width: 0.05.sw,
                  ),
                  Expanded(
                    child: RaisedGradientButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      gradient: LinearGradient(colors: [Colors.white,Colors.black,],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(0.65, 0.0),
                       transform:  GradientRotation(pi /2),
                      ), child: Center(
                      child: WhiteHeadTextWidget(
                        text: "Cancel",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,)
                      ,)
                      ,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}