import 'package:dana/core/utils/app_raduis.dart';
import 'package:flutter/material.dart';

Widget childProfileAvatar({
  required bool isGirl,
  required String? profileUrl,
  required double side,
}) {
  final u = profileUrl;
  final fallbackAsset = isGirl
      ? 'assets/Images/girl_child_photo.png'
      : 'assets/Images/home/boy_child_photo.png';
  if (u != null && u.isNotEmpty && u.startsWith('http')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radius_full),
      child: Image.network(
        key: ValueKey<String>('childAvatar:$u'),
        u,
        width: side,
        height: side,
        fit: BoxFit.cover,
        gaplessPlayback: false,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Image.asset(
            fallbackAsset,
            key: ValueKey<String>('childAvatarFallback:loading:$fallbackAsset'),
            width: side,
            height: side,
            fit: BoxFit.cover,
          );
        },
        errorBuilder: (_, __, ___) => Image.asset(
          fallbackAsset,
          key: ValueKey<String>('childAvatarFallback:error:$fallbackAsset'),
          width: side,
          height: side,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  return Image.asset(
    fallbackAsset,
    key: ValueKey<String>('childAvatarFallback:none:$fallbackAsset'),
    width: side,
    height: side,
    fit: BoxFit.cover,
  );
}
