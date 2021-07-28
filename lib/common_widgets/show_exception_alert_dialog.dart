import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
  String? defaultActionText: 'OK',
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: _message(exception),
      defaultActionText: defaultActionText!,
    );

String _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message!;
  }
  return exception.toString();
}
