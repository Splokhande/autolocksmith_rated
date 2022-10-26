import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/material.dart';

class Loader{

  ProgressDialog dialog = ProgressDialog();
  BuildContext context;
  showLoader(String message, context){
    dialog.showProgressDialog(context,
      textToBeDisplayed: message,
    );
  }

  hideLoader( BuildContext context){
    dialog.dismissProgressDialog(context);

  }
}
