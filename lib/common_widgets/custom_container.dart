import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final Color? borderColor;
  final double? height;
  final double? maxHeight;
  final double? minHeight;
  final double? width;
  final double? minWidth;
  final double? maxWidth;
  final Color? containerColor;
  final double? borderRadius;
  final Gradient? gradient;
  final DecorationImage? decorationImage;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final List<BoxShadow>? boxShadow;

  const CustomContainer({
    Key? key,
    this.child,
    this.borderColor,
    this.height = 100.0,
    this.maxHeight = double.infinity,
    this.minHeight = 100.0,
    this.width = 100.0,
    this.minWidth = 100.0,
    this.maxWidth = double.infinity,
    this.containerColor,
    this.borderRadius = 20.0,
    this.gradient,
    this.decorationImage,
    this.padding,
    this.onPressed,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight!,
          maxHeight: maxHeight!,
          minWidth: minWidth!,
          maxWidth: maxWidth!,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
            color: containerColor,
            gradient: gradient,
            image: decorationImage,
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
