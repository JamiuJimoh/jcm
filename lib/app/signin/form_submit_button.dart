import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    required Widget child,
    required VoidCallback onPressed,
  }) : super(
          child: child,
          height: 48.0,
          // buttonColor:
          onPressed: onPressed,
        );
}
