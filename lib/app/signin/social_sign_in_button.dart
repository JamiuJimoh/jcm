import 'package:flutter/material.dart';

import '../../common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    required String assetName,
    required Widget text,
    TextStyle? textStyle,
    Color? buttonColor,
    required onPressed,
  }) : super(
          buttonColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(assetName),
                text,
                Opacity(opacity: 0.0, child: Image.asset(assetName)),
              ],
            ),
          ),
          height: 48.0,
          // width: double.infinity,
          onPressed: onPressed,
        );
}
