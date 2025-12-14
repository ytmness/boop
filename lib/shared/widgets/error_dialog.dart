import 'package:flutter/cupertino.dart';

class ErrorDialog {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: onPressed ?? () => Navigator.of(context).pop(),
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }
}
