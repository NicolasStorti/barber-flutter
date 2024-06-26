import 'package:flutter/material.dart';

showSnackbar({
  required BuildContext context,
  required String text,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(text),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
        label: "Ok",
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
