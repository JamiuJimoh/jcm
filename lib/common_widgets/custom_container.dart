import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final double? height;
  final double? maxHeight;
  final double? minHeight;
  final double? width;
  final double? minWidth;
  final Color? containerColor;
  final double? borderRadius;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final List<BoxShadow>? boxShadow;

  CustomContainer({
    required this.child,
    this.borderColor,
    this.containerColor,
    this.padding,
    this.height: 100.0,
    this.maxHeight: 100.0,
    this.minHeight: 100.0,
    this.width: 100.0,
    this.minWidth: 100.0,
    this.borderRadius: 20.0,
    this.gradient,
    this.boxShadow,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight!,
          maxHeight: maxHeight!,
          minWidth: minWidth!,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
            color: containerColor,
            gradient: gradient,
            border: borderColor != null
                ? Border(
                    top: BorderSide(color: borderColor!),
                    bottom: BorderSide(color: borderColor!),
                    left: BorderSide(color: borderColor!),
                    right: BorderSide(color: borderColor!),
                  )
                : null,
            boxShadow: boxShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}
