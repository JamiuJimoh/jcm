import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/custom_container.dart';

class PickImageContainer extends CustomContainer {
  PickImageContainer(
    BuildContext context, {
    required Widget child,
    DecorationImage? decorationImage,
  }) : super(
          child: child,
          borderRadius: 5.0,
          // minHeight: 250.0,
          decorationImage: decorationImage,
          minHeight: 250.0,
          maxHeight: 300.0,
          minWidth: 250.0,
          maxWidth: 250.0,
          borderColor: Theme.of(context).primaryColor,
        );
}
