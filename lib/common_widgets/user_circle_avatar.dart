import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:provider/provider.dart';

class UserCircleAvatar extends StatelessWidget {
  UserCircleAvatar({
    this.radius,
    this.imageUrl,
  });
  final double? radius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthBase>(
      builder: (_, auth, __) => buildUserAvatar(auth.currentUser?.photoURL),
    );
  }

  CircleAvatar buildUserAvatar(String? authUserImageUrl) {
    final assetImage = 'assets/images/blank-profile-picture.png';
    if (imageUrl == null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: authUserImageUrl == null
            ? AssetImage(assetImage) as ImageProvider
            : NetworkImage(authUserImageUrl),
        onBackgroundImageError: (obj, str) => AssetImage(assetImage),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundImage: imageUrl!.isEmpty
            ? AssetImage(assetImage) as ImageProvider
            : NetworkImage(
                imageUrl!,
              ),
        onBackgroundImageError: (obj, str) => AssetImage(assetImage),
      );
    }
  }
}
