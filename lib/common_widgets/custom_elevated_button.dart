import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color? buttonColor;
  final double borderRadius;
  final Widget? child;
  final double height;
  final VoidCallback? onPressed;
  final double? width;

  const CustomElevatedButton({
    this.buttonColor,
    this.borderRadius: 5.0,
    required this.child,
    this.height: 40.0,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          primary: buttonColor ?? Theme.of(context).primaryColor,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
