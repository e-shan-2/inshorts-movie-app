import 'package:flutter/material.dart';

class ToastUtils {
  static void showToast(BuildContext context, String message, String? messageType) {
    final backgroundColor = getColorCode(messageType);

    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    ScaffoldMessenger.of(context).clearSnackBars(); // Optional: remove existing snackbars
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color getColorCode(String? messageType) {
    if (messageType == 'error') {
      return Colors.red[300]!;
    } else if (messageType == 'success') {
      return Colors.green[400]!;
    } else if (messageType == 'info') {
      return Colors.blue[300]!;
    } else {
      return const Color.fromARGB(255, 69, 64, 64);
    }
  }
}
