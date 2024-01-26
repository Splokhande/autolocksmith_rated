import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Loader {
  ProgressDialog? dialog;
  showLoader(String message, context) {
    dialog = ProgressDialog(context: context);
    dialog!.show(
      msg: message,
    );
  }

  hideLoader(BuildContext context) {
    dialog!.close();
  }
}
