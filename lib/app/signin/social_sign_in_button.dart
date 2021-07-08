import 'package:flutter/material.dart';

import '../../common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    // required String assetName,
    required Widget text,
    TextStyle? textStyle,
    Color? buttonColor,
    required onPressed,
  }) : super(
          buttonColor: Colors.white,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Image.asset(assetName),
              Text('ho'),
              text,
              Text('ho'),
              // Opacity(opacity: 0.0, child: Image.asset(assetName)),
            ],
          ),
          height: 48.0,
          // width: double.infinity,
          onPressed: onPressed,
        );
}
