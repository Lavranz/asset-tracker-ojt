import 'package:another_flushbar/flushbar.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

toastSuccess(BuildContext context, String message) {
  return Flushbar(
    messageText: Row(
      children: [
        const Icon(
          PhosphorIconsRegular.checkCircle,
          color: AppColors.primary300,
        ),
        const SizedBox(width: 8), // Space between icon and text
        Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
    backgroundColor: AppColors.secondary800, // Green background
    borderRadius: BorderRadius.circular(8),
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.all(16), // Add margin around the Flushbar
    duration: const Duration(seconds: 3), // Duration of the toast
    flushbarStyle: FlushbarStyle.FLOATING, // Float above other UI
    boxShadows: const [
      BoxShadow(
        color: Color.fromRGBO(16, 24, 40, 0.10),
        offset: Offset(0, 4), // x and y offsets
        blurRadius: 8, // Blur radius
        spreadRadius: -2, // Spread radius
      ),
      BoxShadow(
        color: Color.fromRGBO(16, 24, 40, 0.06),
        offset: Offset(0, 2), // x and y offsets
        blurRadius: 4, // Blur radius
        spreadRadius: -2, // Spread radius
      ),
    ],
  ).show(context);
}


nativeToast(String message){
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.positive600,
    webBgColor: 'green',
  );
}

dangerNativeToast(String message){
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.negative600,
    webBgColor: 'red',
  );
}