
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class ShowToast {
  BuildContext context;
  ShowToast.show(String msg, context){
    Toast.show(msg, context,duration: 2);
  }
}