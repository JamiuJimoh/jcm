import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final Color? cursorColor;
  final Color? fillColor;
  final int? maxLines;
  final double? borderRadius;
  final String? labelText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? icon;
  final BorderSide? borderSide;
  final TextInputType? keyboardType;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextFormField({
    Key? key,
    this.style,
    this.textInputAction,
    this.cursorColor,
    this.fillColor,
    this.maxLines,
    this.borderRadius: 5.0,
    this.labelText,
    this.initialValue,
    this.prefixIcon,
    this.icon,
    this.borderSide,
    this.keyboardType,
    this.onSaved,
    this.validator,
    this.obscureText: false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      cursorColor: cursorColor,
      style: style,
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSaved: onSaved,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        icon: icon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius!),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius!),
          ),
          borderSide: BorderSide(color: Theme.of(context).backgroundColor),
        ),
      ),
      validator: validator,
    );
  }
}
