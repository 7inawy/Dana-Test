import 'package:dana/core/utils/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorAvatar extends StatelessWidget {
  final String imageUrl;

  const DoctorAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.trim();
    ImageProvider provider;
    if (url.startsWith('http')) {
      provider = NetworkImage(url);
    } else if (url.isNotEmpty && url.startsWith('assets/')) {
      provider = AssetImage(url);
    } else {
      provider = AssetImage(AppAssets.imageBottomSheet);
    }
    return Container(
      alignment: Alignment.topRight,
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: provider, fit: BoxFit.cover),
      ),
    );
  }
}
