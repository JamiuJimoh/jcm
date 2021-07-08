import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';

class SignInTextField extends CustomTextFormField {
  SignInTextField({
    required Widget prefixIcon,
    required String labelText,
    int maxLines:1,
    bool obscureText: false,
  }) : super(
          borderRadius: 5.0,
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
          labelText: labelText,
          obscureText: obscureText,
          maxLines: maxLines,
        );
}
