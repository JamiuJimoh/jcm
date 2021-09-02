import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/custom_container.dart';

class ShareWithClassContainer extends CustomContainer {
  ShareWithClassContainer({
    required Widget child,
    required Color borderColor,
    required VoidCallback onPressed,
  }) : super(
          maxWidth: 400.0,
          borderRadius: 5.0,
          onPressed: onPressed,
          width: double.infinity,
          minHeight: 65.0,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          borderColor: borderColor,
          child: child,
        );
}
