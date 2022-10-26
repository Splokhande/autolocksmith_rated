import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToast {
  BuildContext context;
  ShowToast.show(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }
}
