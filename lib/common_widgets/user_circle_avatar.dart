import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:provider/provider.dart';

class UserCircleAvatar extends StatelessWidget {
  UserCircleAvatar({this.radius});
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthBase>(
      builder: (_, auth, __) => CircleAvatar(
        radius: radius,
        backgroundImage: auth.currentUser?.photoURL == null
            ? AssetImage('assets/images/blank-profile-picture.png')
                as ImageProvider
            : NetworkImage(
                auth.currentUser!.photoURL!,
              ),
        onBackgroundImageError: (obj, str) =>
            AssetImage('assets/images/blank-profile-picture.png'),
      ),

      // userCircleAvatar(auth.currentUser?.photoURL),
    );
  }
}
