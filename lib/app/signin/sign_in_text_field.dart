import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';

class SignInTextField extends CustomTextFormField {
  SignInTextField({
    required Widget prefixIcon,
    required String labelText,
    required TextEditingController controller,
    required String? errorText,
    required void Function(String)? onChanged,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    bool enabled: true,
    int maxLines: 1,
    bool obscureText: false,
  }) : super(
          borderRadius: 5.0,
          controller: controller,
          errorText: errorText,
          enabled: enabled,
          onChanged: onChanged,
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: labelText,
          obscureText: obscureText,
          maxLines: maxLines,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
        );
}
